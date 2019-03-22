#!/bin/bash
#
#   =======================================================================
#
# Copyright (C) 2018, Hisilicon Technologies Co., Ltd. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   1 Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#
#   2 Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
#   3 Neither the names of the copyright holders nor the names of the
#   contributors may be used to endorse or promote products derived from this
#   software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#   =======================================================================

# ************************Variable*********************************************

script_path="$( cd "$(dirname "$0")" ; pwd -P )"

remote_host=$1
data_source=$2

common_path="${script_path}/../../common"

. ${common_path}/utils/scripts/func_util.sh
. ${common_path}/utils/scripts/func_deploy.sh

function main()
{
    check_ip_addr ${remote_host}
    if [[ $? -ne 0 ]];then
        echo "ERROR: invalid host ip, please check your command."
        exit 1
    fi

    if [[ ${data_source} != "Channel-1" && ${data_source} != "Channel-2" ]];then
        echo "ERROR: invalid data_source, please input Channel-1 or Channel-2."
        exit 1
    fi
    echo "Prepare app configuration..."
    cp -r ${script_path}/facedetectionapp/graph_deploy.config ${script_path}/facedetectionapp/graph.config
    sed -i "s/\${template_data_source}/${data_source}/g" ${script_path}/facedetectionapp/graph.config
    
    parse_remote_port
    
    upload_file ${script_path}/facedetectionapp/graph.config "~/HIAI_PROJECTS/ascend_workspace/facedetectionapp/out"
    if [[ $? -ne 0 ]];then
        echo "ERROR: sync ${script_path}/facedetectionapp/graph.config ${remote_host}:./HIAI_PROJECTS/ascend_workspace/facedetectionapp/out failed, please check /var/log/slog for details."
        exit 1
    fi
    echo "Finish to prepare facedetectionapp params."
    exit 0
}

main