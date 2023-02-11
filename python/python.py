# Generate query as string with dynamic parameters from .sql file
# In .sql file add parameters like following: {{ <param_name> }}
import jinja2
def load_templated_sql(filename: str, **kwargs) -> str:
    with open(file = filename, mode= 'r') as f:
        raw_sql = f.read()
    environment = jinja2.Environment()
    print(raw_sql)
    template = environment.from_string(raw_sql)
    return template.render(**kwargs)
print(load_templated_sql('query.sql', column='kol'))

# Load json file and parse to dictionary
# import json
def load_json_file_to_dict(file_path) -> None:
    with open(file_path) as json_file:
        data = json.load(json_file)
    return data
