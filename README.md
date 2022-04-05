# web-downloader
Toolkit for bulk downloading from the web

## Requirements
[curl](https://curl.se/) is used for getting web pages and elements. The script will check to see if it is installed and try to install it if it isn't. If you run this as a non-sudo user, you will need to install curl before the script will run for you.

## Usage

The script simple-get.sh can be run directly by typing

	./simple-get.sh
	
By default, this will open a text file called listofurls.txt and download the contents of the listed website to Documents/web-downloader. If this directory doesn't exist, it will be created.

For more advanced usage, there are a number of flags to control the script's behavior. They include:

-d DESTINATION 	
: Set DESTINATION directory for the downloaded files. By default it is $HOME/Documents/web-downloader

-f SOURCE_FILE 	
: Set FILE for the list of URLs. By default it is ./listofurls.txt. You can include whatever path information you might need.

-h 				
: Help and command syntax.

-n				
: Dry run mode. Display the URLs that would have been downloaded and exit without actually downloading anything. Useful for checking if the script will read your text file.

-t TIMEOUT		
: Set individual connection TIMEOUT. By default this is 3.0

-v 				
: Verbose mode. Displays the additional information about each step.



If you found this helpful, feel free to buy me a cup of coffee:

bitcoin: bc1q8tsj7zf86z46smq6edlaumukugq7amv3e96fau

dash: XeXV73CLavGyMk9tPsV8DRzeeACKAPw8jf

