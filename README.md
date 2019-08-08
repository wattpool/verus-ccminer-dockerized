# Dockerized Verus ccminer

Verus-ccminer is now hosted on docker hub.  You can get it there, or built it yourself:

## Pull the image from docker hub
```shell
docker pull wattpool/verusccminer
```

...or build it yourself:

## Clone the repo
```shell
git clone https://github.com/wattpool/verus-ccminer-dockerized.git
```

## Build the container
```shell
cd verus-ccminer-dockerized
docker build -t verusccminer .
```

## Run the miner
```shell
docker run --name verusccminer verusccminer -a verus -o stratum+tcp://verus.wattpool.net:1232 -u WALLET_ADDRESS.WORKER_NAME -p x -tX
```

Replace `WALLET_ADDRESS` with your verus address, `WORKER_NAME` with a workername that will be displayed on the pool and `-tX` with the number of threads that you would like to run the miner on eg. `-t4` for 4 threads.

### Tip
Run miner in background using `screen`.
```shell
screen -dmS verusminer docker run verusccminer -a verus -o stratum+tcp://verus.wattpool.net:1232 -u RMJid9TJXcmBh2BhjAWXqGvaSSut2vbhYp.dockerworker -p x -t4
```
This will run the containerized miner in a screen named `verusminer`, you can see what is running inside that screen by entering the command `screen -r verusminer` and detach from that screen with `[ctrl]+a d` (that is the ctrl and a keys together, then d for detach), if you do ctrl+c you will quit the miner.

## Running the miner container in the background:

1. Build the docker image for the miner.

   When using this feature, it is recommended to build the container with your wallet and worker ID baked into the image.

   * Edit the `Dockerfile` and replace `RMJid9TJXcmBh2BhjAWXqGvaSSut2vbhYp.dockerized` with your own WALLET_ADDRESS.WORKER_NAME

   * Rebuild the docker image:
   ```shell
   docker build -t verusccminer .
   ```

2. Create a new container using the newly built docker image:

```
docker container create verusccminer
```

This command will output a long hash.

3. Start the new container referenced by the long hash from the previous step:

```
docker container start {that long hash}
```

* You can combine steps 2 & 3 into a single command:

```
docker container start `docker container create verusccminer`
```

* You can limit CPU usage by passing arguments to the `docker container create` command:

```
docker container start `docker container create --cpus=".7" verusccminer`
```

* If you need to stop the container, you can use the command:

```
docker container stop {that long hash}
```

* Restart the container with the command:

```
docker container restart {that long hash}
```

4. You can view the running container and see the newly assigned name with the command:

```
docker container ls
```

5. View container logs using that newly assigned name:

```
docker container logs -f that-container-name
```

## Running the miner container as a systemd service using the Makefile:

Assuming you have created a user `verusminer` in group `verusminer` and have cloned this repository in the `verusminer` home user directory, the following service file will start the daemon automatically at system startup.

Adjust the percentage of CPU being allocated to the process by editing the file `cpus.txt`.  By default, this is set to 35% - feel free to change this value.

Enter the following into `/etc/systemd/system/verusccminer.service`:

```
[Unit]
Description=Verus ccminer daemon service
After=network.target

[Service]
User=verusminer
Group=verusminer
Type=simple
Restart=always
RestartSec=90s
WorkingDirectory=/home/verusminer/verus-ccminer-dockerized
ExecStart=/usr/bin/make miner

[Install]
WantedBy=default.target
```

---

## Command Line Options
Full list of CLI options for this version of ccminer
```shell
  -a, --algo=ALGO       specify the algorithm to use
                          allium      use to mine Garlic
                          bastion     use to mine Joincoin
                          bitcore     use to mine Bitcore's Timetravel10
                          blake       use to mine Saffroncoin (Blake256)
                          blakecoin   use to mine Old Blake 256
                          blake2s     use to mine Nevacoin (Blake2-S 256)
                          bmw         use to mine Midnight
                          cryptolight use to mine AEON cryptonight variant 1 (MEM/2)
                          cryptonight use to mine original cryptonight
                          c11/flax    use to mine Chaincoin and Flax
                          decred      use to mine Decred 180 bytes Blake256-14
                          deep        use to mine Deepcoin
                          dmd-gr      use to mine Diamond-Groestl
                          equihash    use to mine ZEC, HUSH and KMD
                          fresh       use to mine Freshcoin
                          fugue256    use to mine Fuguecoin
                          groestl     use to mine Groestlcoin
                          hsr         use to mine Hshare
                          jackpot     use to mine Sweepcoin
                          keccak      use to mine Maxcoin
                          keccakc     use to mine CreativeCoin
                          lbry        use to mine LBRY Credits
                          luffa       use to mine Joincoin
                          lyra2       use to mine CryptoCoin
                          lyra2v2     use to mine Vertcoin
                          lyra2z      use to mine Zerocoin (XZC)
                          monero      use to mine Monero (XMR)
                          myr-gr      use to mine Myriad-Groest
                          neoscrypt   use to mine FeatherCoin, Trezarcoin, Orbitcoin, etc
                          nist5       use to mine TalkCoin
                          penta       use to mine Joincoin / Pentablake
                          phi1612     use to mine Seraph
                          phi2        use to mine LUXCoin
                          polytimos   use to mine Polytimos
                          quark       use to mine Quarkcoin
                          qubit       use to mine Qubit
                          scrypt      use to mine Scrypt coins (Litecoin, Dogecoin, etc)
                          scrypt:N    use to mine Scrypt-N (:10 for 2048 iterations)
                          scrypt-jane use to mine Chacha coins like Cache and Ultracoin
                          s3          use to mine 1coin (ONE)
                          sha256t     use to mine OneCoin (OC)
                          sia         use to mine SIA
                          sib         use to mine Sibcoin
                          skein       use to mine Skeincoin
                          skein2      use to mine Woodcoin
                          skunk       use to mine Signatum
                          sonoa       use to mine Sono
                          stellite    use to mine Stellite (a cryptonight variant)
                          timetravel  use to mine MachineCoin
                          tribus      use to mine Denarius
                          x11evo      use to mine Revolver
                          x11         use to mine DarkCoin
                          x12         use to mine GalaxyCash
                          x13         use to mine X13
                          x14         use to mine X14
                          x15         use to mine Halcyon
                          x16r        use to mine Raven
                          x16s        use to mine Pigeon and Eden
                          x17         use to mine X17
                          vanilla     use to mine Vanilla (Blake256)
                          veltor      use to mine VeltorCoin
                          whirlpool   use to mine Joincoin
                          wildkeccak  use to mine Boolberry (Stratum only)
                          zr5         use to mine ZiftrCoin

  -d, --devices         gives a comma separated list of CUDA device IDs
                        to operate on. Device IDs start counting from 0!
                        Alternatively give string names of your card like
                        gtx780ti or gt640#2 (matching 2nd gt640 in the PC).

  -i, --intensity=N[,N] GPU threads per call 8-25 (2^N + F, default: 0=auto)
                        Decimals and multiple values are allowed for fine tuning
      --cuda-schedule   Set device threads scheduling mode (default: auto)
  -f, --diff-factor     Divide difficulty by this factor (default 1.0)
  -m, --diff-multiplier Multiply difficulty by this value (default 1.0)
  -o, --url=URL         URL of mining server
  -O, --userpass=U:P    username:password pair for mining server
  -u, --user=USERNAME   username for mining server
  -p, --pass=PASSWORD   password for mining server
      --cert=FILE       certificate for mining server using SSL
  -x, --proxy=[PROTOCOL://]HOST[:PORT]  connect through a proxy
  -t, --threads=N       number of miner threads (default: number of nVidia GPUs in your system)
  -r, --retries=N       number of times to retry if a network call fails
                          (default: retry indefinitely)
  -R, --retry-pause=N   time to pause between retries, in seconds (default: 15)
      --shares-limit    maximum shares to mine before exiting the program.
      --time-limit      maximum time [s] to mine before exiting the program.
  -T, --timeout=N       network timeout, in seconds (default: 300)
  -s, --scantime=N      upper bound on time spent scanning current work when
                        long polling is unavailable, in seconds (default: 5)
      --submit-stale    ignore stale job checks, may create more rejected shares
  -n, --ndevs           list cuda devices
  -N, --statsavg        number of samples used to display hashrate (default: 30)
      --no-gbt          disable getblocktemplate support (height check in solo)
      --no-longpoll     disable X-Long-Polling support
      --no-stratum      disable X-Stratum support
  -q, --quiet           disable per-thread hashmeter output
      --no-color        disable colored output
  -D, --debug           enable debug output
  -P, --protocol-dump   verbose dump of protocol-level activities
  -b, --api-bind=port   IP:port for the miner API (default: 127.0.0.1:4068), 0 disabled
      --api-remote      Allow remote control, like pool switching, imply --api-allow=0/0
      --api-allow=...   IP/mask of the allowed api client(s), 0/0 for all
      --max-temp=N      Only mine if gpu temp is less than specified value
      --max-rate=N[KMG] Only mine if net hashrate is less than specified value
      --max-diff=N      Only mine if net difficulty is less than specified value
      --max-log-rate    Interval to reduce per gpu hashrate logs (default: 3)
      --pstate=0        will force the Geforce 9xx to run in P0 P-State
      --plimit=150W     set the gpu power limit, allow multiple values for N cards
                          on windows this parameter use percentages (like OC tools)
      --tlimit=85       Set the gpu thermal limit (windows only)
      --keep-clocks     prevent reset clocks and/or power limit on exit
      --hide-diff       Hide submitted shares diff and net difficulty
  -B, --background      run the miner in the background
      --benchmark       run in offline benchmark mode
      --cputest         debug hashes from cpu algorithms
      --cpu-affinity    set process affinity to specific cpu core(s) mask
      --cpu-priority    set process priority (default: 0 idle, 2 normal to 5 highest)
  -c, --config=FILE     load a JSON-format configuration file
                        can be from an url with the http:// prefix
  -V, --version         display version information and exit
  -h, --help            display this help text and exit
```
