# Ansible Notes

## Disable fact checking in order to improve task execution time

- Enable it when nececary

```
gather_facts: false
```



rc - Return Code
stdout - Entier content of stdout
stderr - Error code?

```yaml
# Example plaubook
---
- hosts: localhost
  gather_facts: false
  tasks:
    - name: Get the current date.
      command: date
      register: current_date
      changed_when: false
    - name: Print the current date.
      debug:
        msg: "{{ current_date.stdout }}"
```

```yaml 
# Example execution
ansible-playbook -i inventory main.yaml
```

## Install the k8s module managed via openshift

```yaml
pip3 install openshift
```