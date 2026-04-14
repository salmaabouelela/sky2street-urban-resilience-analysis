# Sky2Street: Urban Resilience Analysis Using Earth Observation Data

## Overview
Sky2Street is a data-driven project that integrates environmental, social, and health-related data to assess urban resilience. The project transforms complex Earth observation data into an intuitive and actionable system for decision-makers.

The goal is to support smarter, more sustainable city planning through a unified resilience analysis framework.

## Problem Statement
Urban planners often analyze environmental issues (such as heat, air pollution, or flooding) separately. This fragmented approach makes it difficult to identify high-risk areas and prioritize interventions effectively.

As a result, cities struggle to develop comprehensive and data-driven resilience strategies. 

## Solution
Sky2Street introduces a **City Resilience Composite Index (CRCI)** that integrates multiple datasets into a single, unified resilience score.

The system:
- Combines NASA Earth Observation data with local datasets  
- Converts complex data into a simple traffic-light system (Green / Yellow / Red)  
- Enables quick identification of safe, moderate, and high-risk areas  

This allows decision-makers to easily understand and act on urban resilience insights. 

## Tools & Technologies
- R (data analysis and modeling)
- RStudio (development environment)
- Geospatial visualization (Kepler.gl)
- NASA EarthData (AOD, LST, NDVI, precipitation)
- GIS techniques
- Data integration & visualization

## Key Features
- Multi-layer environmental data integration  
- Interactive urban resilience map  
- Composite index (CRCI) for decision-making  
- Visualization of district-level risk levels  
- Clear and interpretable outputs for non-technical users  

## Dataset
- NASA Earth Observation data (AOD, NDVI, LST, etc.)
- Local environmental and urban datasets
- Geographic data (district-level analysis)

## What I Did
- Integrated multiple environmental datasets into a unified framework  
- Designed and developed a composite resilience index (CRCI)  
- Built geospatial visualizations to represent risk levels  
- Transformed complex data into user-friendly outputs  
- Contributed to analysis, interpretation, and presentation of results  

## Key Insights
- Urban resilience varies significantly across districts  
- Environmental risks (heat, pollution, vegetation) are interconnected  
- A combined index provides more actionable insights than isolated indicators  
- Data-driven visualization helps prioritize high-risk areas effectively  

## Target Users
- Municipalities and local governments  
- Urban planners  
- Environmental agencies  
- Research institutions and universities :contentReference[oaicite:2]{index=2}  

## Project Preview

### Resilience Map Visualization:


![a4806f52-3ea1-44fd-a0be-bcf8f9c63dc7](https://github.com/user-attachments/assets/010310d6-dffb-48d1-b1d2-84a5ea0e0163)

### Interface:

![9ce3d5f3-a680-47b1-855a-c809023c8ee4](https://github.com/user-attachments/assets/7490d049-b103-4d44-b5ae-307e935bd15e)


### Data Visualization 


<img width="786" height="447" alt="image" src="https://github.com/user-attachments/assets/beb3fcbe-0de4-44dc-ab10-ef0f65b341a6" />



Visualization Interpretation

This visualization compares multiple environmental indicators—Resilience Index, NDVI (vegetation), LST (land surface temperature), and AOD (air pollution)—across different districts.

The results reveal clear spatial disparities in urban resilience:

### Beykoz, Şile, and Çatalca show high resilience levels, supported by:
High NDVI (strong vegetation presence)
Lower LST (cooler surface temperatures)
Lower AOD levels (better air quality)

These areas can be considered environmentally stable and lower-risk zones

### Esenyurt, Bağcılar, and Küçükçekmece exhibit lower resilience levels, characterized by:
Low NDVI (limited green spaces)
High LST (urban heat effect)
Higher AOD (increased air pollution)

These districts represent higher-risk areas requiring intervention


(Add charts like NDVI, LST, AOD comparison)

## Files in This Repository
- `sky2street.pdf` – Full project presentation and methodology  
- `Istanbul_AOD.xlsx` – Aerosol Optical Depth (air pollution indicator) dataset  
- `Istanbul_LST.xlsx` – Land Surface Temperature dataset  
- `Istanbul_NDVI.xlsx` – Vegetation index dataset  
- `Istanbul_Precipitation.xlsx` – Precipitation dataset  

## Impact
This project supports:
- Sustainable urban development (SDG 11)  
- Data-driven policy making  
- Climate resilience planning  

## Author
Salma Sobhy
