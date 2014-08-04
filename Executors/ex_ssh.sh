#!/usr/bin/env bash

ex_ssh() {
    ssh root@$1 "$2"
}

tb_update_executor ex_ssh cli
