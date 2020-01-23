*  Docker base image to build EOS

An base image with all the necessary dependencies to build [EOS](https://github.com/EOSIO/eos.git)

Example Usage:

```
$ git clone --recurse-submodules https://github.com/EOSIO/eos.git
$ cd eos
$ docker run --rm -v $PWD:$PWD -w $PWD/build -it huangminghuang/eos_builder bash -c "cmake .. -DCMAKE_BUILD_TYPE=Debug -GNinja && ninja"
$ alias make_eos="docker run --rm -v $PWD:$PWD -w $PWD/build -it huangminghuang/eos_builder ninja"
$ make_eos
```

To run the compiled executable on your ubuntu based linux host, make sure you have the following packages installed

```
sudo apt-get install -y libssl1.1 libcurl3-gnutls libusb-1.0-0
```