module VariableNameMap = MapClass.Make (VariableNameHash)

class ['data] container = ['data] VariableNameMap.container
