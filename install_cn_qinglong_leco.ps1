$Env:HF_HOME = "huggingface"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
$Env:PIP_NO_CACHE_DIR = 1
function InstallFail {
    Write-Output "安装失败。"
    Read-Host | Out-Null ;
    Exit
}

function Check {
    param (
        $ErrorInfo
    )
    if (!($?)) {
        Write-Output $ErrorInfo
        InstallFail
    }
}

if (!(Test-Path -Path "venv")) {
    Write-Output "正在创建虚拟环境..."
    python -m venv venv
    Check "创建虚拟环境失败，请检查 python 是否安装完毕以及 python 版本是否为64位版本的python 3.10、或python的目录是否在环境变量PATH内。"
}

.\venv\Scripts\activate
Check "激活虚拟环境失败。"

Write-Output "安装程序所需依赖 (已进行国内加速，若在国外或无法使用加速源请换用 install.ps1 脚本)"
$install_torch = Read-Host "是否需要安装 Torch+xformers? 若您本次为首次安装请选择 y ，若本次为升级依赖安装则选择 n。[y/n] (默认为 y)"
if ($install_torch -eq "y" -or $install_torch -eq "Y" -or $install_torch -eq ""){
    pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html -i https://mirror.baidu.com/pypi/simple
    Check "torch 安装失败，请删除 venv 文件夹后重新运行。"
    pip install -U -I --no-deps xformers==0.0.20 -i https://mirror.baidu.com/pypi/simple
    Check "xformers 安装失败。"
}

pip install --upgrade -r requirements.txt -i https://mirror.baidu.com/pypi/simple
Check "其他依赖安装失败。"

pip install --upgrade pytorch_lightning -i https://mirror.baidu.com/pypi/simple
Check "pytorch-lighting安装失败。"

pip install ./bitsandbytes_windows/bitsandbytes-0.39.1-py3-none-win_amd64.whl
Check "其他依赖安装失败。"

Write-Output "安装 bitsandbytes..."
cp .\bitsandbytes_windows\*.dll .\venv\Lib\site-packages\bitsandbytes\
cp .\bitsandbytes_windows\main.py .\venv\Lib\site-packages\bitsandbytes\cuda_setup\main.py

Write-Output "安装完毕"
Read-Host | Out-Null ;
