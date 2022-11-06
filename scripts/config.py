import os
from contextlib import suppress
import json

class Config:
    def __init__(self):
        self.environ = os.environ

        with open(".secrets.json", "r") as file:
            self.env = json.load(file)

        with open("settings.env.json", "r") as file:
            self.settings = json.load(file)

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