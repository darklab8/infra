package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/moby/moby/client"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	containerHealth = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "docker_container_health_status",
			Help: "Docker container health status: 1=healthy, 0=unhealthy, -1=none",
		},
		[]string{"container", "service"},
	)
	containerFailingStreak = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "docker_container_health_failing_streak",
			Help: "Anything above 0 is bad",
		},
		[]string{"container", "service"},
	)
)

func recordMetrics(cli *client.Client) {
	containers, err := cli.ContainerList(context.Background(), client.ContainerListOptions{All: true})
	if err != nil {
		log.Printf("Error listing containers: %v", err)
		return
	}

	for _, c := range containers {
		inspect, err := cli.ContainerInspect(context.Background(), c.ID)
		if err != nil {
			log.Printf("Error inspecting container %s: %v", c.ID, err)
			continue
		}

		// Default: no healthcheck defined
		healthValue := float64(-1)

		failing_streak := 0

		if inspect.State != nil && inspect.State.Health != nil {
			switch inspect.State.Health.Status {
			case "healthy":
				healthValue = 1
			case "unhealthy":
				healthValue = 0
			default:
				healthValue = -1
			}

			failing_streak = inspect.State.Health.FailingStreak
		}

		serviceName := inspect.Config.Labels["com.docker.swarm.service.name"]
		if serviceName == "" {
			serviceName = inspect.Name
		}

		containerName := inspect.Name
		containerHealth.WithLabelValues(containerName, serviceName).Set(healthValue)
		containerFailingStreak.WithLabelValues(containerName, serviceName).Set(float64(failing_streak))
	}
}

func main() {
	// Register Prometheus metric
	prometheus.MustRegister(
		containerHealth,
		containerFailingStreak,
	)

	// Docker client (from env: DOCKER_HOST, /var/run/docker.sock, etc.)
	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		log.Fatalf("Error creating Docker client: %v", err)
	}

	// Start HTTP server
	http.Handle("/metrics", promhttp.Handler())
	go func() {
		for {
			recordMetrics(cli)
			time.Sleep(30 * time.Second)
		}
	}()

	fmt.Println("Exporter listening on :9100/metrics")
	log.Fatal(http.ListenAndServe(":9100", nil))
}
