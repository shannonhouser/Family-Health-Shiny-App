This folder contains the data and source code necessary to list providers, community organizations, and to make maps.

It is structured as follows:
- **input:** Data files in csv and xlsx format
- **src:** Source code processing the data files. Data objects are saved to "../data".

In order to re-run all data processing scripts, use the following commands:
```sh
cd data-raw
make all
```
