import kcls.models.github_action as gh

_name = "Checkout Freelancer"
_filename = "checkout-freelancer"
_checkoutFrelancer: gh.GHAction = {
    name = _name
    inputs: {
        "freelancer-folder": {
            description = "Path to root of freelancer directory"
            default = r"${{ github.workspace }}"
        }
        "freelancer-mod": {
            description = "insert vanilla or discovery"
            required = True
        }
        "ssh-key-base64-vanilla": {
            description = "Key to download Freelancer vanilla repo"
            default = ""
        }
        "ssh-key-base64-discovery": {
            description = "Key to download Discovery repo"
            default = ""
        }
    }
    runs = {
        steps = [
            gh.Step {
                name = "Write vanilla id_rsa down"
                $if = r"${{ inputs.freelancer-mod == 'vanilla' }}"
                shell: "python"
                run = r"""import base64
import os
file_output_name = "${{ github.workspace }}/id_rsa.out"
with open(file_output_name, "wb", 0o600) as file:
    file.write(base64.b64decode(bytes(os.environ["ID_RSA_FILE_IN_BASE64"], encoding='utf8')))
os.chmod(file_output_name, 0o600)
"""
                env = {
                    ID_RSA_FILE_IN_BASE64: r"${{ inputs.ssh-key-base64-vanilla }}"
                }
            }
            gh.Step {
                name = "Write discovery id_rsa down"
                $if = r"${{ inputs.freelancer-mod == 'discovery' }}"
                shell: "python"
                run = r"""import base64
import os
file_output_name = "${{ github.workspace }}/id_rsa.out"
with open(file_output_name, "wb", 0o600) as file:
    file.write(base64.b64decode(bytes(os.environ["ID_RSA_FILE_IN_BASE64"], encoding='utf8')))
os.chmod(file_output_name, 0o600)
"""
                env = {
                    ID_RSA_FILE_IN_BASE64: r"${{ inputs.ssh-key-base64-discovery }}"
                }
            }
            gh.Step {
                shell: "bash"
                run = " ".join([
                    r"GIT_SSH_COMMAND='ssh -i ${{ github.workspace }}/id_rsa.out -o IdentitiesOnly=yes'"
                    r"git clone git@github.com:darklab8/fl-files-${{ inputs.freelancer-mod }}.git"
                ])
            }
            gh.Step {
                shell: "bash"
                "continue-on-error": True
                run = r"mv fl-files-${{ inputs.freelancer-mod }} ${{ inputs.freelancer-folder }}"
            }
        ]
    }
}

_key_discovery = r"${{ secrets.ID_RSA_FILES_FREELANCER_DISCOVERY }}"
_key_vanilla = r"${{ secrets.ID_RSA_FILES_FREELANCER_VANILLA }}"
_mod_discovery = "discovery"
_mod_vanilla = "vanilla"
schema CheckoutFreelancerOpts(gh.StepOpts):
    "freelancer-mod": "discovery" | "vanilla"
    "freelancer-folder": str
    "ssh-key-base64-discovery"?: str
    "ssh-key-base64-vanilla"?: str

schema CheckoutArgs:
    freelancer_mod: "discovery" | "vanilla"
    freelancer_folder: str
    $if?: str

NewCheckoutFreelancer = lambda a: CheckoutArgs {
    CheckoutFreelancer {
        $if = a.if
        if a.freelancer_mod == _mod_discovery:
            with = CheckoutFreelancerOpts {
                "freelancer-mod": a.freelancer_mod
                "freelancer-folder": a.freelancer_folder
                "ssh-key-base64-discovery": _key_discovery
            }
        if a.freelancer_mod == _mod_vanilla:
            with = CheckoutFreelancerOpts {
                "freelancer-mod": a.freelancer_mod
                "freelancer-folder": a.freelancer_folder
                "ssh-key-base64-vanilla": _key_vanilla
            }
    }
}

schema CheckoutFreelancer(gh.Step):
    name: str = _name
    uses: str = r"darklab8/infra/.github/actions/checkout-freelancer@master"
    with: CheckoutFreelancerOpts

