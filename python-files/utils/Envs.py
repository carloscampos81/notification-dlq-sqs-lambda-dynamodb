from dotenv import dotenv_values

config = dotenv_values('.env')

def get_env(attr_name : str, is_array : bool = False):
    value = config.get(attr_name)
    if(is_array):
        array_ = value.strip().replace("[","").replace("]","")
        if not bool(array_): return []
        array_ = array_.split(",")
        for index in range (0, len(array_)):
            array_[index] = array_[index].strip()
        return array_

    return value

