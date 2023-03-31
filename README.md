# plexRenamer

Utility to rename Plex files with built in PowerShell, along with a service to push them to a remote Plex server


This is a WIP project!


### Purpose:

The purpose of this utulity is to allow Windows users who use Plex to rename there dwonloaded content without having to download other coding langauge like Python. This project will just use PowerShell as it is native to Windows.

The innital PowerShell will just create dirs on a drive of your choice, and will rename content based on TMDB API.

The second part of this project, which will be optional to certain users, will use NSSM (or just basic Windows service) to automatically push the renamed media to a remote plex server by SFTP.



### Plan:

1. Get basic renamer utility finished - Partially finished, havent finished API part
   1. Basic rename with user input and for loop
   2. Match new renamed content to TMDB API
   3. Move content to the staging sub dir in the host trasnfer dir
2. Create NSSM service
   1. Will use NSSM to make a service that detects when files have been finished renamed.
   2. New PS script + SFTP method to push to remote Plex server.
