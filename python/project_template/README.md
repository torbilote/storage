# py-template
py-template

# Set up environment
py -m pip install pip --upgrade
py -m pip install virtualenv
py -m virtualenv .venv --python=python3.xx -v
.venv/Scripts/Activate
py -m pip install -r -requirements.txt

# Run Ruff
ruff check . --fix -v
ruff format . -v

# Run Pyright
pyright --verbose

# Run Pytest
pytest -vv

# Run snoop
import snoop
Add @snoop decorator to any function