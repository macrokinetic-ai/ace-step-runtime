# ace-step-runtime

A CUDA 12.8 runtime image for [ACE-Step 1.5](https://github.com/ace-step/ACE-Step-1.5), pinned to commit `ca1e85f`. It comes with all Python dependencies installed (PyTorch 2.10 cu128, nano-vllm, triton, hf_transfer/Xet) and with gcc, which triton needs.

**No model weights are included.** Download them at start-up from Hugging Face (`hf download ACE-Step/...`). The image contains only open-source code: no keys and no data.

```
ghcr.io/macrokinetic-ai/ace-step-runtime:ca1e85f
```

The image is built by `.github/workflows/build.yml` on GitHub Actions, for linux/amd64, from `pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime`. ACE-Step is MIT-licensed; see its repository for the model licences.
