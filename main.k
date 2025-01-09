import kcls.actions.checkout_freelancer as cf
import kcls.actions.install_autogit as autogit
import kcls.actions.install_darklint as darklint
import kcls.actions.install_go as go
import kcls.actions.install_taskfile as taskfile
import kcls.actions.install_templ as templ
import kcls.actions.patch_disco as disco
import yaml

yaml.dump_to_file(
    cf._checkoutFrelancer, 
    ".github/actions/checkout-freelancer/action.yml",
    ignore_private=True,
    ignore_none=True,
)
yaml.dump_to_file(
    autogit._action, 
    ".github/actions/install-autogit/action.yml",
    ignore_private=True,
    ignore_none=True,
)
yaml.dump_to_file(
    autogit._action, 
    ".github/actions/install-autogit/action.yml",
    ignore_private=True,
    ignore_none=True,
)
yaml.dump_to_file(
    darklint._action, 
    ".github/actions/${darklint._filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
yaml.dump_to_file(
    go._action, 
    ".github/actions/${go._filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
yaml.dump_to_file(
    taskfile._action, 
    ".github/actions/${taskfile._filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
yaml.dump_to_file(
    templ._action, 
    ".github/actions/${templ._filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
yaml.dump_to_file(
    disco._action, 
    ".github/actions/${disco._filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)