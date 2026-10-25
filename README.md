# ReXGlue SDK com AMD FidelityFX — compilação para os ports do Otavix

Este repositório guarda uma compilação do [ReXGlue SDK](https://github.com/rexglue/rexglue-sdk) para Windows (x64), igual à nightly oficial **0.10.0.24** (commit `bd833a2`), com uma diferença: a opção `REXGLUE_ENABLE_FIDELITYFX` ligada.

A nightly oficial vem sem o FidelityFX. Nela, a apresentação só tem a ampliação bilinear. Com o FidelityFX, o runtime passa a ter:

- **AMD FSR 1** (EASU + RCAS): ampliação espacial com bordas nítidas, com nitidez ajustável;
- **AMD CAS**: nitidez adaptativa;
- o caminho temporal experimental do runtime (FSR 2/3 com profundidade e movimento sintetizados).

Os geradores dos ports de Xbox 360 do [Otavix Launcher](https://github.com/otavix010/otavix-launcher) (`gerar.ps1`) baixam este pacote do release e conferem o SHA-256.

## Como foi compilado

`sdk-fidelityfx.cmd`, com o Clang 23.1.3 e o Visual Studio 2022 Build Tools:

```
cmake -S rexglue-sdk -B build -G Ninja -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_C_FLAGS="-march=x86-64-v2" -DCMAKE_CXX_FLAGS="-march=x86-64-v2" -DCMAKE_CXX_STANDARD=23 ^
  -DREXGLUE_ENABLE_FIDELITYFX=ON -DREXGLUE_ENABLE_TRACY=ON -DCMAKE_INSTALL_PREFIX=...\win-amd64
cmake --build build && cmake --install build
```

No Windows, os links simbólicos dos submódulos (o libmspack, por exemplo) precisam virar cópias antes de compilar (`git config core.symlinks` desligado os grava como texto).

## Licenças

- ReXGlue SDK: BSD 3-Clause (`LICENSE-rexglue.txt`).
- AMD FidelityFX SDK: MIT (`LICENSE-fidelityfx.txt`).
- As bibliotecas de terceiros do SDK seguem as licenças de cada uma, as mesmas da distribuição oficial.

Este repositório não tem relação com o projeto ReXGlue nem com a AMD.
