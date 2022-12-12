import logging
import os
import sys
import tomllib
from pathlib import Path
from getpass import getpass
from paramiko import SSHClient
from paramiko import AutoAddPolicy
from scp import SCPClient

logging.basicConfig(level=logging.INFO)
logging.getLogger("paramiko").setLevel(logging.WARN)
logger = logging.getLogger(__name__)

password = getpass(prompt="Enter vyos password: ")

with open(os.path.join(sys.path[0], "servers.toml"), "rb") as f:
    data = tomllib.load(f)

for server in data.get("servers"):
    name = server.get("name")
    ip = server.get("ip")

    logger.info(f"Starting config backup for {name}")

    with SSHClient() as ssh:
        ssh.set_missing_host_key_policy(AutoAddPolicy())
        ssh.connect(ip, port=22, username="vyos", password=password)

        with SCPClient(ssh.get_transport()) as scp:
            output_path = os.path.join(
                str(Path(__file__).resolve().parent.parent), f"{name}.boot")
            scp.get('/config/config.boot',
                    local_path=output_path)

            logger.info(
                f"Finished backup of {name}. Backup file located at {output_path}")
