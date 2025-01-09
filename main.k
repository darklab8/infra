import kcls.actions.checkout_freelancer as cf
import kcls.actions.install_autogit as autogit
import kcls.actions.install_darklint as darklint
import kcls.actions.install_go as go
import kcls.actions.install_taskfile as taskfile
import kcls.actions.install_templ as templ
import kcls.actions.patch_disco as disco
import kcls.models.github_action as ga
import yaml

schema ActionBuild:
    action: ga.GHAction
    filename: str

_actions = [
    {action = cf._checkoutFrelancer, filename = cf._filename}
    {action = autogit._action, filename = autogit._filename}
    {action = darklint._action, filename = darklint._filename}
    {action = go._action, filename =  go._filename}
    {action = taskfile._action, filename =  taskfile._filename}
    {action = templ._action, filename = templ._filename}
    {action = disco._action, filename = disco._filename}
]

_run = [yaml.dump_to_file(
    a.action, 
    ".github/actions/${a.filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
) for a in _actions]
