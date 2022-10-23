import os
import configparser
from contextlib import suppress

class Config:
    def __init__(self):
        self.environ = os.environ

        env = configparser.ConfigParser()
        env.read("env.ini")
        self.env = env["DEFAULT"]

        settings = configparser.ConfigParser()
        settings.read("settings.ini")
        self.settings = settings["DEFAULT"]

    def __getitem__(self, key: str):
        key = key.upper()

        with suppress(KeyError):
            return self.environ[key]

        with suppress(KeyError):
            return self.env[key]

        with suppress(KeyError):
            return self.settings[key]
                
        raise KeyError(f"missing {key=}")

    def get(self, key: str, default=None):
        key = key.upper()
        with suppress(KeyError):
            return self.environ[key]

        with suppress(KeyError):
            return self.env[key]

        with suppress(KeyError):
            return self.settings[key]

        return default