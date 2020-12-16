## What's this

Terraformでネットワーク周りあらかた作ってくれる使い捨てスクリプトです

## CIDR

VPCのCIDRを `10.0.0.0/16` とした場合、以下のようなCIDR内訳となります。
（AZの名称）

|CIDR|用途|
|:-:|:-:|
|10.0.0.0/20|Public Subnet, AZ a|
|10.0.16.0/20|Public Subnet, AZ c|
|10.0.32.0/20|Public Subnet, AZ d|
|10.0.48.0/20|Public Subnet, 予備のため作成されません|
|10.0.64.0/20|Private Subnet, AZ a|
|10.0.80.0/20|Private Subnet, AZ c|
|10.0.96.0/20|Private Subnet, AZ d|
|10.0.112.0/20|Private Subnet, 予備のため作成されません|
|10.0.128.0/17|予備（固定IP用等のレンジとしてお使いください）|


## 免責事項

本リポジトリのファイルを利用したことで発生する問題に対して、当方は一切の責任・補償義務を負いません。
