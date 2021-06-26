package ps.analysis

import input as tf

default allow = false

variables_allowed[msg] {
    lookup := data.parameters[_].self
    policy := data.parameters[lookup].allowed
    value := tf.variables[lookup].value
    policy[i] == value 
	msg := lookup
 
}
variables_denied[msg] {
    lookup := data.parameters[_].self
    policy := data.parameters[lookup].allowed
    value := tf.variables[lookup].value
    policy[i] != value 
	msg := lookup
 
}

variable_failures[msg] {
    result := variables_denied - variables_allowed
    msg := result
}

# proto[msg] {
#     lookup := data.variables[_].self
#     policy := data.variables[lookup].allowed
#     value := arm.parameters[lookup].value
#     value == policy[i]
#     msg := {"result": "success",
#             "name": lookup}
# }
# eval_vnet_name[msg] {
#     policy := data.variables.vnetName.allowed
#     value := arm.parameters.vnetName.value
#     value == policy[i]
#     msg := {"result": "something",
#             "name": "whatever"}
# }
# eval_subnet_name[msg] {
#     policy := data.variables.subnetName.allowed
#     value := arm.parameters.subnetName.value
#     value == policy[i]
#     #msg := {"result": "success"}
#     msg := {"result": "success",
#             "name": data.variables.subnetName.self
#     }
# }
eval_character_length_pass[msg] {  
    lookup := data.parameters[_].self
    policy := data.parameters[lookup].nchar
    value := tf.variables[lookup].value
    num_char = count(value)
    num_char <= policy
    msg := lookup
}

eval_character_length_fail[msg] {  
    lookup := data.parameters[_].self
    policy := data.parameters[lookup].nchar
    value := tf.variables[lookup].value
    num_char = count(value)
    num_char >= policy
    msg := lookup
}

eval_character_length_diff[msg] {
    result := eval_character_length_fail - eval_character_length_pass
    msg := {"failed": result}
}

eval_var_weight[msg] {
    lookup := data.parameters
    policy := count(lookup)
    value := count(tf.variables)
    result := value - policy
    result >= 0
    msg := {"missing_policy": result,
            "status": "warn"}
}

allow = true {
    count(variable_failures) == 0
}