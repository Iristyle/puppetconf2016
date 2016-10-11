When using Code Manager with SSH, this directory should have files like:

* code-manager.pub - public SSH key
* code-manager.key - private SSH key

roles.yaml should be updated with the `puppet_enterprise::profile::master::r10k_private_key` setting accordingly
