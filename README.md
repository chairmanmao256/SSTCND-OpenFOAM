# OpenFOAM Implementation of The SST-CND Model 
## Overview
This is an OpenFOAM Implementation of the SST-CND model described in [this article](https://arxiv.org/ftp/arxiv/papers/2402/2402.16355.pdf). The SST-CND model is based on Menter's Shear-stress-transport model with a correction term for separated flow (especially separated shear layer) derived by machine learning method. The correction term has a closed analytical form, which is derived by symbolic regression method. This characteristic ensures the model to be interpretable and computationally economic. The SST-CND model is tested on various 2D and 3D cases and shows good generalizability.

The implementation is tested on OpenFOAM-v2312, OpenFOAM-v2306 and works fine.

## Contact the authors
Chenyu Wu, Tsinghua University (wcy22@mails.tsinghua.edu.cn)

Yufei Zhang, Tsinghua University (zhangyufei@tsinghua.edu.cn)

## Performance
Below are some comparisons between the SST-CND model and the SST model in various 2D and 3D cases. More detailed comparisons can be found in [this article](https://arxiv.org/ftp/arxiv/papers/2402/2402.16355.pdf). Note that Cf's mean square error in the separation zone is compared in the Hump case and the CBFS case. The error of the SST model is scaled to 100%. The NLR7301 high lift device is computed by CFL3D.

| Case name| Hump | CBFS | NLR7301(CFL3D)| SAE 3D Car
| --       | --   |  --  | -- | -- |
| SST      | Cf MSE: 100%| Cf MSE: 100% | CLmax err: 6.3% | CD err 10.7%
| SST-CND  | Cf MSE: **6.5%**| Cf MSE: **32%**  | CLmax err: **1.0%** | CD err: **3.7%**

Besides the separated flows, the SST-CND model only deviates  **1%** from the Cf prediction of the baseline SST model in the zero-pressure-gradient flat plate, demonstrating its ability to protect attached boundary layer from being negatively impacted by the correction. This is done by applying a technique called **Conditioned field inversion (FI-CND)** in the data assimilation process. For more information about this method can be found in [this article](https://arxiv.org/ftp/arxiv/papers/2402/2402.16355.pdf).

## How to install
First, you should have OpenFOAM-v2312 installed on your system. Then you can follow the steps below to compile the model.

* Clone the repository to anywhere you want on your system (you can also just download the `zip` file from GitHub if you wish):
    ```
    git@github.com:chairmanmao256/SSTCND-OpenFOAM.git
    ```

* From the root of the repository, run the following commands:
    ```
    cd src/TurbulenceModels/incompressible
    wclean
    wmakeLnInclude -u ../turbulenceModels
    wmake
    cd ../compressible
    wclean
    wmakeLnInclude -u ../turbulenceModels
    wmake
    ```
    Note that after the compilation completed, the `.so` files are stored in `$FOAM_USER_LIBBIN`.
* If you want to use the model for your simulation:
    * add the following line to the `system/controlDict` file (just pick one of them depending on your case):
        ```
        // For incompressible flows
        lib(libCNDIncompressibleTurbulenceModels)

        // For compressible flows
        lib(libCNDCompressibleTurbulenceModels)
        ```
    * specify the turbulence model in `constant/turbulenceProperties`
        ```
        RASModel kOmegaSSTCND
        ```

## Run the tutorial cases
Two tutorial cases are included in the [cases](./cases) directory. They are the NASA hump (`cases/NASA-hump`) and the zero gradient flat plate (`cases/ZPG-flatPlate`). To run the tutorial cases, just type the following command in each case:
```shell
./Allrun.sh
```
Depending on your system, you might have to do some `chmod` stuffs before running the script to make or `.sh` files in the tutorial cases executable:
```
chmod 755 *.sh
```
The `Allrun.sh` script runs both the baseline SST model and the SST-CND model for the given case and compare their results.

After running the script, if you have `gnuplot` correctly installed on your system (`sudo apt-get install gnuplot`), you can reproduce the following images. The Cf distribution in the NASA hump case shows that the SST-CND model is able to predict a separation zone closer to the experiment. On the other hand, the Cf distribution in the ZPG flat plate case shows that the SST-CND model does not negatively impact the baseline SST model's performance in zero-pressure-gradient boundary layer.

![HumpCf](./Figures/Hump-Cf.png)
![ZPGCf](./Figures/ZPG-Cf.png)

## Cite the model
If you find the SST-CND model interesting and helpful to your work, please cite the paper:
```
@misc{wu2024development,
      title={Development of a Generalizable Data-driven Turbulence Model: Conditioned Field Inversion and Symbolic Regression}, 
      author={Chenyu Wu and Yufei Zhang},
      year={2024},
      eprint={2402.16355},
      archivePrefix={arXiv},
      primaryClass={physics.flu-dyn}
}
```