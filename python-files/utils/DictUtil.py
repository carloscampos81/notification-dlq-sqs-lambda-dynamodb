import json

def find_dict_value_from_attr_name(attr : str, dict : dict):
    if(dict.get(attr)):
        return dict[attr]
    return None

def dict_to_json(dict : dict, indent : int = 4):
    json_object = json.dumps(dict, indent = indent, ensure_ascii=False, default=str)
    return json_object
