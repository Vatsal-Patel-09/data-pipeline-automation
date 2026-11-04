@echo off
REM ===================================================================
REM  SynthForge - one entry point for everything.
REM
REM    run.bat              preflight, pipeline at 5%, API, website
REM    run.bat full         the same, at full scale (100,400 records)
REM    run.bat site         website only
REM    run.bat api          API server only
REM    run.bat pipeline [s] pipeline only, optional scale (default 0.05)
REM    run.bat offline      everything with no database at all
REM    run.bat test         the test suite
REM    run.bat clean        drop the model's tables from the database
REM    run.bat check        preflight only: python, deps, .env, database
REM    run.bat install      install dependencies
REM    run.bat help         this message
REM ===================================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"

set "PY=python"
set "ACTION=%~1"
if "%ACTION%"=="" set "ACTION=demo"

if /i "%ACTION%"=="help"     goto :usage
if /i "%ACTION%"=="-h"       goto :usage
if /i "%ACTION%"=="--help"   goto :usage
if /i "%ACTION%"=="install"  goto :install
if /i "%ACTION%"=="check"    goto :check
if /i "%ACTION%"=="clean"    goto :clean
if /i "%ACTION%"=="test"     goto :test
if /i "%ACTION%"=="site"     goto :site
if /i "%ACTION%"=="api"      goto :api
if /i "%ACTION%"=="pipeline" goto :pipeline
if /i "%ACTION%"=="offline"  goto :offline
if /i "%ACTION%"=="full"     goto :demo
if /i "%ACTION%"=="demo"     goto :demo

echo Unknown action: %ACTION%
echo.
goto :usage


REM ------------------------------------------------------------------
:usage
echo.
echo   SynthForge
echo   ----------------------------------------------------------------
echo   run.bat                preflight, pipeline at 5%%, API, website
echo   run.bat full           the same, at full scale ^(100,400 records^)
echo   run.bat site           website only
echo   run.bat api            API server only
echo   run.bat pipeline [s]   pipeline only, optional scale ^(default 0.05^)
echo   run.bat offline        everything with no database at all
echo   run.bat test           the test suite
echo   run.bat clean          drop the model's tables from the database
echo   run.bat check          preflight only
echo   run.bat install        install dependencies
echo.
echo   Only pipeline and api need a database. site, offline and the
echo   default test run work without one.
echo.
exit /b 0


REM ------------------------------------------------------------------
:needpython
%PY% --version >nul 2>&1
if errorlevel 1 (
  echo [X] Python was not found on PATH.
  echo     Install Python 3.11+ and reopen this window.
  exit /b 1
)
exit /b 0


REM ------------------------------------------------------------------
:install
call :needpython || exit /b 1
echo Installing dependencies...
%PY% -m pip install -r requirements.txt
if errorlevel 1 ( echo [X] pip install failed. & exit /b 1 )
echo [ok] Dependencies installed.
exit /b 0


REM ------------------------------------------------------------------
:check
call :needpython || exit /b 1
echo.
echo   Preflight
echo   ----------------------------------------------------------------
for /f "delims=" %%v in ('%PY% --version 2^>^&1') do echo   [ok] %%v

%PY% -c "import psycopg2,faker,fastapi,uvicorn,dotenv,pandas,pyarrow,click" >nul 2>&1
if errorlevel 1 (
  echo   [X] Some dependencies are missing. Run: run.bat install
  exit /b 1
)
echo   [ok] Dependencies importable

if not exist ".env" (
  echo   [!] .env not found. Copy example.env to .env and fill it in.
  echo       Without it only 'site', 'offline' and 'test' will work.
) else (
  echo   [ok] .env present
)

echo   [..] Checking the model contract
%PY% data_pipeline.py validate --model ecommerce_model.json >nul 2>&1
if errorlevel 1 (
  echo   [X] Model failed validation. Run: python data_pipeline.py validate
  exit /b 1
)
echo   [ok] Model is valid

if exist ".env" (
  echo   [..] Reaching the database ^(this can take a few seconds^)
  %PY% -c "import sys;sys.path.insert(0,'.');from dotenv import load_dotenv;load_dotenv('.env');from src.db import connect;c=connect();c.close();print('   [ok] Database reachable')" 2>nul
  if errorlevel 1 (
    echo   [!] Database not reachable. 'offline' and 'site' still work.
  )
)
echo.
exit /b 0


REM ------------------------------------------------------------------
:clean
call :needpython || exit /b 1
echo.
echo   Dropping the tables this model declares. Nothing else is touched.
echo.
%PY% data_pipeline.py clean-db --model ecommerce_model.json --env .env
exit /b %errorlevel%


REM ------------------------------------------------------------------
:test
call :needpython || exit /b 1
echo.
echo   Running the test suite. Database-marked tests skip without a database.
echo.
%PY% -m pytest -q
exit /b %errorlevel%


REM ------------------------------------------------------------------
:pipeline
call :needpython || exit /b 1
set "SCALE=%~2"
if "%SCALE%"=="" set "SCALE=0.05"
echo.
echo   Running the pipeline at scale %SCALE%
echo.
%PY% data_pipeline.py run --scale %SCALE% --load-all --verify-writes
exit /b %errorlevel%


REM ------------------------------------------------------------------
:offline
call :needpython || exit /b 1
echo.
echo   Offline: generating and writing every file sink, no network.
echo.
%PY% data_pipeline.py --offline --scale 0.05
if errorlevel 1 ( echo [X] Offline run failed. & exit /b 1 )
echo.
echo   Starting the API server from the generated file, then the website.
start "SynthForge API (offline)" cmd /k "%PY% api_server.py --offline --port 8000"
timeout /t 3 /nobreak >nul
start "SynthForge website" cmd /k "%PY% serve_demo.py --port 8900"
echo.
echo   API     : http://127.0.0.1:8000/docs
echo   Website : http://127.0.0.1:8900/
echo   Close those two windows to stop them.
echo.
exit /b 0


REM ------------------------------------------------------------------
:site
call :needpython || exit /b 1
echo.
echo   Starting the website. The Live run page can trigger the real pipeline.
echo.
%PY% serve_demo.py --port 8900
exit /b %errorlevel%


REM ------------------------------------------------------------------
:api
call :needpython || exit /b 1
echo.
echo   Starting the API server on port 8000. Docs at /docs
echo.
%PY% api_server.py --port 8000
exit /b %errorlevel%


REM ------------------------------------------------------------------
:demo
call :needpython || exit /b 1
call :check
if errorlevel 1 exit /b 1

set "SCALE=0.05"
if /i "%ACTION%"=="full" set "SCALE=1.0"

echo   Pipeline
echo   ----------------------------------------------------------------
echo   Scale %SCALE%, every declared table loaded, writes verified.
echo.
%PY% data_pipeline.py run --scale %SCALE% --load-all --verify-writes
if errorlevel 1 (
  echo.
  echo   [X] The pipeline failed. See runs\run_report.json for the traceback.
  echo       The website still runs: try  run.bat site
  exit /b 1
)

echo.
echo   Servers
echo   ----------------------------------------------------------------
start "SynthForge API" cmd /k "%PY% api_server.py --port 8000"
timeout /t 3 /nobreak >nul
start "SynthForge website" cmd /k "%PY% serve_demo.py --port 8900"

echo   API     : http://127.0.0.1:8000/docs
echo   Website : http://127.0.0.1:8900/
echo.
echo   The website opens by itself. Its Live run page has a button that
echo   runs this pipeline again and streams the logs back to the browser.
echo   Close the two server windows to stop them.
echo.
exit /b 0
