To have it working with grcp without tcl and with tcl for golang client, u need stuff like
```hcl
{
  servers {
    protocols h1 h2 h2c
  }
}

darkgrpc.dd84ai.com:80 {
    reverse_proxy {
      to production-darkstat-app:50051
      transport http {
          versions h1 h2c
      }
    }
}

darkgrpc.dd84ai.com:443 {
    reverse_proxy h2c://production-darkstat-app:50051
}
```
