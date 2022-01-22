# COSC-499-Medical-Imaging

Project Name: Traceable Medical Image De-Identification

Authors:
1. Kshitij Suri
2. Daniil Khodosko
3. Jace Lai

# Quick Tour
- ```auxFiles``` contains documentation
- ```auxFiles/MeetingNotes/``` contains our weekly sprint notes and client notes

# How To Use
We have a two orthanc server setup. 

First launch both servers using:

```docker-compose up --build```

Next send DICOM images to Orthanc-server1, from here Orthanc-server1 saves the files, and routes them to Orthanc-server2-anonymized.

Orthanc-server1 is running on http://localhost:8044 

Orthanc-server2-anonymized is running on http://localhost:8042

# Purpose 
The project aims at creating an automated x-ray image pipeline, to provide mammography scans to experts to analyze using AI for cancer prediction of the breast tissue. 

# Extra

To understand the project better please take a look at the DesignDocument folder and Read the high level section.


You can also view the DFD folder to see the data flow diagrams. The flowcharts explain the dataflow of the mammograph and patient information from the Patient to the user who is trying to retrieve the information.
The Level 0 flowchart gives a general understanding whereas in Level 1 we get a more detailed understading of all the steps involved in the dataflow.

# Problem Statement

Currently, a female patient attends a clinic to receive a mammogram. After an x-ray scan is complete an image file is created called a DICOM file. DICOM files contain the actual image as well as patient metadata. Patient metadata includes identifiable patient information such as, name, sex, birth date, patient id, clinic id, etc, and contains non-identifiable information such as time of the scan, type of machine for scan, image view, etc.  

The image is sent to a medical server via a secure medical image protocol called DIMSE. Those images are then stuck on that physical server in the clinic. Dr. Rajapakshe then has to physically drive to the clinic (approximately every 6 months), remove the hard drive, download the data onto a research server, delete the old DICOM files from the hard drive, and finally, drive the empty hard drive back to the clinic. 

Once the files are on the research server, they are anonymized. The purpose is to open these images to scientists to analyze, but these DICOM files must not contain any Patient Health Information (PHI). There are then two servers. One contains the anonymized DICOM images and the other contains only patient metadata, which is kept confidential. The anonymized DICOM images are then released for research.

# Proposed solution

The proposed process will set up two new servers using open-source software called Orthanc. Once the mammography scan is complete the DICOM file will be sent to the first Orthanc server (via DIMSE protocol) which will store the confidential metadata, anonymize the DICOM file, and create a random new ID to connect the patient health information to the anonymized DICOM file. The anonymized DICOM file is then sent to another Orthanc server. This server has a GUI (Graphical User Interface) which will be used by researchers to download the x-ray scans and perform analysis. 

This project will save Dr. Rajapakshe time, and allow for a faster release of new anonymized DICOM files. Instead of having to wait 6 months for new scans, the scans will be available to research almost as soon as the scan itself is complete.

# Notes:
- Truncate date, have customizability for this
- Keep date of birth to year or month 
- Truncate to middle of the month for date of birth
- Keep study date as is
- Truncate date of birth to 15th of the month (allow to adjust if needed)
- 

