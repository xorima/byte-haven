ansible-first-run:
	@op item get "admin-user" --vault sg-k8s --reveal --fields label=initial-password > admin-password.txt
	@ansible-playbook -u "$(shell op item get "admin-user" --vault sg-k8s --reveal --fields label=username)" --private-key admin-password.txt -i ansible/inventory/hosts.yaml ansible/base.yaml -e "ansible_sudo_pass=$(shell cat admin-password.txt) my_user=$(shell op item get "my-user" --vault sg-k8s --reveal --fields label=username) my_password=$(shell op item get "my-user" --vault sg-k8s --reveal --fields label=password-enc)" --ssh-common-args='-o StrictHostKeyChecking=no'
	@rm admin-password.txt

ansible-base: 
	@ansible-playbook -i ansible/inventory/hosts.yaml ansible/base.yaml --ssh-common-args='-o StrictHostKeyChecking=no'  -e "my_user=$(shell op item get "my-user" --vault sg-k8s --reveal --fields label=username) my_password='$(shell op item get "my-user" --vault sg-k8s --reveal --fields label=password-enc)'"

ansible-k3s: 
	@ansible-galaxy install -r ansible/collections/requirements.yml
	@ansible-playbook -i ansible/inventory/hosts.yaml ansible/k3s-install.yaml --ssh-common-args='-o StrictHostKeyChecking=no' -e "token=$(shell op item get "k3s-token" --vault sg-k8s --reveal --fields label=token) my_username=$(shell op item get "admin-user" --vault sg-k8s --reveal --fields label=username) my_password=$(shell op item get "admin-user" --vault sg-k8s --reveal --fields label=initial-password)"
