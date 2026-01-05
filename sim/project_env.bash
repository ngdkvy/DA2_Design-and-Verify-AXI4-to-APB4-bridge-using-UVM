#!/bin/bash -f

setup_dva

## UVM library path
export UVM_HOME=/ictc/other/tools/QuestaDVA/questasim/verilog_src/uvm-1.2

## Verify root path
export APB_IP_VERIF_PATH=./..

## AXI VIP Design root path
export AXI_VIP_ROOT=$APB_IP_VERIF_PATH/vip/axi_vip

## APB VIP Design root path
export APB_VIP_ROOT=$APB_IP_VERIF_PATH/vip/apb_vip
