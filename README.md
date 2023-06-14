# COVID-19 Data Exploration Project

This personal project aims to provide a comprehensive analysis of COVID-19 data by exploring a rich dataset. I wrote a series of SQL commands to understand the progression of the virus in terms of infections and deaths, as well as testing and vaccination rates to study their effects on various demographics, and identify potential correlations and trends.  

## Content

[1. Getting Started](#getting-started)  
&emsp;[1.1 Requirements](#requirements)  
[2. Download and Installation](#download-and-installation)  
[3. Data Source](#data-source)  
[4. Data Exploration Process](#data-exploration-process)  
[5. License](#license)  

## Getting Started

The following instructions will help you get a copy of this project and execute the queries to observe the result sets they generate.

### Requirements

You need to have any DBMS (Database Management System) installed on your system that supports the standard SQL syntax and functions, such as MySQL, PostgreSQL, Microsoft SQL Server **(the one I used)**, Oracle, or others.

It's also recommended to have a Database Manager such as MySQL Workbench or Microsoft SQL Server Management Studio so you can work better with the queries and visualize their results.

## Download and Installation

1. You can clone this repository or simply download the .zip file by clicking on 'Code' -> 'Download ZIP' at <https://github.com/luiscoelhodev/covid-data-exploration>.

2. Once you have all the files of this project, you can find the dataset in different tables in excel files in the 'tables' folder. They need to be imported into a new database or an existing one so the queries can be executed against them.

3. Open your SQL DB Manager, create a new database or use an existing one to import the excel files into tables. The steps may vary depending on the DB manager you are using. Here is a general approach: In your DB manager, locate the option to import data from a file or external source ->
Select the Excel files one by one and follow the prompts to specify the target table and mapping of columns ->
Verify that the data has been imported successfully by checking the table contents.

4. The queries I wrote for this project can be found in the 'queries' folder. You can open the files directly to run them or create new query windows to copy/paste them into the editor.  

5. Execute the query you want to retrieve the desired results.  

**Note:** Please ensure you have a valid database connection established in your DB manager before executing the queries. Adjust the queries if needed based on the structure of the imported tables.

## Data Source

The original dataset I used for this project can be found and downloaded from <https://ourworldindata.org/covid-deaths>.

For the purposes of this project, I modified the original dataset and shaped it into those three tables in the 'tables' folder.

## Data Exploration Process

I started by exploring the original dataset to see the possibilities it gave me. After that, I started writing the first queries myself and got some insights for more prompting ChatGPT.

Main SQL commands/statements used: Joins, CTE's, Temp Tables, Window Functions, Aggregate Functions, Converting Data Types, Case statements, Creating Views.  

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
