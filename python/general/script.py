
def load_templated_sql(filename: str, **kwargs) -> str:
    import jinja2

    with open(file=filename, mode="r") as f:
        raw_sql = f.read()
    environment = jinja2.Environment()
    # print(raw_sql)
    template = environment.from_string(raw_sql)
    return template.render(**kwargs)

def load_json_file_to_dict(file_path: str) -> dict:
    import json

    with open(file_path) as json_file:
        data = json.load(json_file)
    return data

def decorator(func):
    import functools

    @functools.wraps(func)
    def wrapper_decorator(*args, **kwargs):
        # Do something before
        value = func(*args, **kwargs)
        # Do something after
        return value
    return wrapper_decorator