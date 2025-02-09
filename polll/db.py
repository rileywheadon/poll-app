from dotenv import dotenv_values

import os
from flask import g, session
from supabase.client import create_client, Client, ClientOptions
from gotrue import SyncSupportedStorage


class FlaskSessionStorage(SyncSupportedStorage):
    def __init__(self):
        self.storage = session

    def get_item(self, key: str) -> str | None:
        if key in self.storage:
            return self.storage[key]

    def set_item(self, key: str, value: str) -> None:
        self.storage[key] = value

    def remove_item(self, key: str) -> None:
        if key in self.storage:
            self.storage.pop(key, None)

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_KEY")

def get_db():
    if "supabase" not in g:
        g.supabase = Client(
            url,
            key,
            options=ClientOptions(
                storage=FlaskSessionStorage(),
                flow_type="pkce"
            ),
        )
    return g.supabase
