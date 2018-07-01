# bitsee

![bitsee](http://i.imgur.com/p38ijb7.jpg =300x300)

(bitsee the chihuahua is too busy sleeping to care about infringments on her name or image)

# Simple CCTV for the raspberry pi using omxplayer

bitsee is composed of two components:

A server component that handles generating a list of camera ips on whatever network is given to it (uses nmap to find open port 85) and then spawns a thread to run a simple tcp server and a ffmpeg thread to record the list of camera ips.

Eventually this server might have a simple ncurses interface for changing settings and other utilities.

A client component that is intended to run on raspberry pi's (rpi3).  The idea is to produce an iso that can be copied to any sdcard which will contain an archlinux ARM installation running openbox.  The raspberry automatically starts X and then runs the client program to connect to the TCP server where it receives the list of camera ips.  It then takes this list and uses it to generate n amount of omxplayer instances to display the cameras.   The program will calculate the screen topography based on how many cameras were received.  Eventual advanced feautures should allow for display patterns (for instance display each camera round robin and fullscreen) and possibly support for a web interface or touchscreen to control the cameras.

# Requirements

FFMPEG
nmap
chicken-scheme 4.x using tcp-server egg

The program should remain as light as possible.  FFMPEG will only copy the camera stream to reduce encoding overhead.  The server will need to handle organzing the video files and possibly concatenating all files for a particular camera after a 24 hour period (possibly in a different encoding)

# Future Optimizations
