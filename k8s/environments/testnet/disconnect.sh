#!/usr/bin/env bash

set -e

kill -9 $(lsof -ti:8888)
