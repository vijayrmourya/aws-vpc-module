#!/bin/bash

run_command(){
    if ! $1; then
        echo "command execution failed! Command: $1"
        return 0
    fi
}

tf_apply(){
    run_command "terraform plan -out=tfplan -var-file=default.tfvars"
    read -p "Do you want to apply the plan[yes/NO]" CHOICE
    if [[ $CHOICE != "yes" ]]; then 
        return 0
    fi
    run_command "terraform apply --auto-approve -input=false -compact-warnings tfplan"
}

tf_destroy(){
    run_command "terraform plan -destroy -out=tfplan.destroy -var-file=default.tfvars"
    read -p "Do you want to apply the destroy plan[yes/NO]" CHOICE
    if [[ $CHOICE != "yes" ]]; then 
        return 0
    fi
    run_command "terraform apply --auto-approve -input=false -compact-warnings tfplan.destroy"
}

cred_file="/home/bloodborne/Artificial_volume/opt/Portfolio/AWS/aws_creds.json"

eval "$(
    jq -r 'to_entries
        | map("\(.key)=\(.value|@sh)") 
        | .[]' $cred_file
)"

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

aws sts get-caller-identity

run_command "terraform init"
run_command "terraform fmt -recursive"
run_command "terraform validate"

if [[ $1 == "apply" ]]; then
    tf_apply
elif [[ $1 == "destroy" ]]; then
    tf_destroy
fi