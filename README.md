# DevConf

DevConf is a make file that helps you to add all necessary dev packages and initiate git for your laravel project.


## Pre-requisites
`make` should be installed on your system.

## Installation

```
curl -o ./makefile https://raw.githubusercontent.com/drmovi/devconf/main/makefile && make
```

## Usage

the above command will create a makefile in your project directory and run the `init` command.

If you already have git initialized, you can use the following command to add all necessary dev packages and override your git pre-commit.

```
make init force=true
```

## For run pipeline test

```
make test
```

## For run pipeline linting

```
make lint
```

## Or you can use the following command run all pipeline checks

```
make pipline
```
