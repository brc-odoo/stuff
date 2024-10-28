#!/bin/bash

scrub_db() {
    db_zip=$(readlink -f "$1")
    ~/.setup-db.sh $db_zip "$2"
}
