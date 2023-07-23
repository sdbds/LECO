# LoRA train script by @bdsqlsz

#训练模式(Lora、Sdxl_lora)
$train_mode = "lora"

# Train data config | 设置训练配置路径
$config_file = "./examples/config.yaml" # config path | 配置路径

# ============= DO NOT MODIFY CONTENTS BELOW | 请勿修改下方内容 =====================
# Activate python venv
.\venv\Scripts\activate

$Env:HF_HOME = "huggingface"
$Env:XFORMERS_FORCE_DISABLE_TRITON = "1"
$ext_args = [System.Collections.ArrayList]::new()
$laungh_script = "train_lora"

if ($train_mode -ilike "sdxl*"){
  $laungh_script = $laungh_script + "_xl"
}

# run train
accelerate launch --num_cpu_threads_per_process=8 "./$laungh_script.py" `
  --config_file=$config_file

Write-Output "Train finished"
Read-Host | Out-Null ;