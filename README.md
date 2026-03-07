# ch.rip-dockerized - chirp eBook downloader Dockerized

Chapter Rip (ch.rip) is a tool to download an optionally pack the audio files for the books you have purchased on ChirpBooks. This is my spin of [Bostwickenator/ch.rip](https://github.com/Bostwickenator/ch.rip).  I have created a Docker container that pre-loads the pre-requisites and allows you to access the instance via a browser rather than having your screen stolen by the Selenium driver while you're doing other things.  This allows you to also host it somewhere other than your desktop.

### *This is for personal use only for books you have PURCHASED.  Do not distribute them*


This project owes a lot to the automation orginally from https://gist.github.com/nfriedly/1d0f81fd68addd594d4974923205c384 the sequence of which is maintained here.

## Setup 🚀

* download the .zip of this repo, or git clone
* go into the newly created directory
* copy the env.example file to create a new .env file setting your /output location and VNC password if applicable.  
**you will get errors if you forget this step**



## Usage ▶️

----
### Starting the container and access
1. ```docker compose up``` 
   * On the first build it will take a while for Chrome and Selenium to install, be patient. 

2. In your web browser, navigate to the host (or localhost) that you are running from from **HTTP**  i.e., ```http://localhost:6080```.  There is no https yet unless you want to front this with a proxy such as traefik, Caddy, or nginx.  You are on your own to modify the docker-compose file for that.  .  

3. Log in to chirp, select your book by clicking the **COVER**  not the title. 

4. Go to the first chapter of the book!! Press the play button. The script will now jump through all the chapters snooping on and downloading the files for you.  A random backoff timer has been put in place, forcing a wait between 15 and 60 seconds between file downloads.  This will help keep Chirp from banning your IP and giving you 403 errors.  
Files will go into the output folder you set in the .env file.  

5. The script closes the book tab. You may now select another book or exit the browser window.

#### NOTE
* On any error, or closing the Chrome Testing window, the container will crash and will need to be restarted again.  

----
### Repacking books **(Not officially supported in the docker container...yet)** [TODO]

*You 'could' do this via the command line IN the docker container using the instructions below, but I am working on some automation that will put the completed books in a folder and output them to a single chapterized file for you via the repack.js script.  If you do it from the container, you're on your own on how you get the files out.*

Repacking books converts the folder of chapter files into a single audiobook file with chapter metadata and book cover. This make it easier to transfer your books to your mobile device.

1. Navigate your command line to the directory containing this readme then run
   > `node repack.js FOLDER_NAME`
2. Delete the book folder if you don't need the individual chapters

## Notes 📝
If you encounter issues, check the console output for error messages. When reporting a bug please include your browser version, operating system, and book title.

## Changelog 📜
### `2.0.0` - 2026-03-06 - Going to keep the number scheme
#### Fixed
- Created DockerFile that pulls in all pre-requisites and makes setup easy
#### Improved
- Added a random backoff sleep timer function between 15 and 60 seconds that stops most 403s
- Inside Docker, you no longer get the screen steal when files change.  You can continue to use your computer if this is running locally. 
#### Known Issues:
- Container crashes upon close of Chrome or error in script.  This is expected behavior. 
- Placing this in the container, makes repack.js much harder to use.  A script is in work to automate combining the audio files into a single file and putting it in the defined /output directory as well.  
   - move the downloaded folders to a new directory with repack.js and process them.  
   - I am refactoring repack.js for more arguments in the future to accomodate the automation, but will be useful for those only using the script directly as well.  


### `1.3.0` - 2026-01-12
#### Fixed
- Using chrome itself to download the snooped URLs. A tad slower but works again!
#### Improved
- Improved some error messages
- Resume from last downloaded chapter

### `1.2.0` - 2025-10-29
#### Fixed
- Updated the approach to use chrome for testing. A testing version of chrome will now be installed for this script to use. This will resolve issues with extension loading.

### `1.1.0` - 2025-06-15
#### Fixed
- Fix for Chrome extension loading by adding `--disable-features=DisableLoadExtensionCommandLineSwitch` flag
- Updated dependencies (chromedriver from v127 to v137)

### `1.0.1` - 2025-04-09
#### Fixed
- Empty audio file downloads (0 byte .m4a files) by adding `__cf_bm` and `mj_wp_scrt` cookies to requests
- Merged PR #18 from tjxn to fix audio download functionality

### `1.0.0` - 2025-01-15
#### Improved
- Filename handling to support em dashes (—) in book titles (fixes issue #10)
- Initial stable release
