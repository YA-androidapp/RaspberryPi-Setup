<a id="markdown-raspberrypi-setup" name="raspberrypi-setup"></a>

# RaspberryPi-Setup

---

<!-- TOC -->

- [RaspberryPi-Setup](#raspberrypi-setup)
  - [Raspberry Pi Imager](#raspberry-pi-imager)
  - [boot ドライブのルート直下にファイル追加](#boot-ドライブのルート直下にファイル追加)
    - [Web サービス](#web-サービス)
    - [コマンド](#コマンド)
  - [Raspberry Pi を起動](#raspberry-pi-を起動)
  - [SSH 接続](#ssh-接続)
  - [アップデート](#アップデート)
  - [初期設定](#初期設定)
    - [ウィザードで設定する場合](#ウィザードで設定する場合)
    - [コマンドで設定する場合](#コマンドで設定する場合)
  - [IP アドレスを固定](#ip-アドレスを固定)

<!-- /TOC -->

---

<a id="markdown-raspberry-pi-imager" name="raspberry-pi-imager"></a>

## Raspberry Pi Imager

[Win](https://downloads.raspberrypi.org/imager/imager_latest.exe) [Mac](https://downloads.raspberrypi.org/imager/imager_latest.dmg)

<a id="markdown-boot-ドライブのルート直下にファイル追加" name="boot-ドライブのルート直下にファイル追加"></a>

## boot ドライブのルート直下にファイル追加

- `ssh` ... 空のファイル
- `wpa_supplicant.conf` ... 以下の内容で作成

<details open>
<summary>平文パスフレーズを指定する場合（ダブルクォーテーションで囲む）</summary>

```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=JP
network={
	ssid="SSID"
	psk="PASSPHRASE"
}
```

</details>

<details>
<summary>パスフレーズを指定する場合（ダブルクォーテーションで囲まない）</summary>

```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=JP
network={
	ssid="SSID"
	psk=ENCRYPTED_PASSPHRASE
}
```

パスフレーズの暗号化は以下の Web サービス or コマンドで行う

<a id="markdown-web-サービス" name="web-サービス"></a>

### Web サービス

[WPA key calculation](http://jorisvr.nl/wpapsk.html)

<a id="markdown-コマンド" name="コマンド"></a>

### コマンド

```sh
# Ubuntu
$ sudo apt install wpasupplicant
$ wpa_passphrase SSID PASSPHRASE
```

```
network={
        ssid="SSID"
        #psk="PASSPHRASE"
        psk=38497220976092fc2707a838e4d4385019256149f99f935be22c90159d3b8373
}
```

</details>

<a id="markdown-raspberry-pi-を起動" name="raspberry-pi-を起動"></a>

## Raspberry Pi を起動

<a id="markdown-ssh-接続" name="ssh-接続"></a>

## SSH 接続

REM LAN のアドレスの範囲を確認

```cmd
$ ipconfig | grep IPv4
```

アドレスの範囲に合わせて `192.168.0.%i` の部分を変更。MAC アドレスをもとに Raspberry Pi を探す

```cmd
$ for /l %i in (0,1,255) do ping -w 1 -n 1 192.168.0.%i
$ arp -a | grep b8-27-eb-
$ arp -a | grep dc-a6-32-
```

```
  192.168.0.31          dc-a6-32-70-f0-86     動的
```

SSH 接続

```cmd
$ ssh pi@192.168.0.XX
```

ユーザー名・初期パスワードは `pi` `raspberry`

<a id="markdown-アップデート" name="アップデート"></a>

## アップデート

```sh
$ sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
```

<a id="markdown-初期設定" name="初期設定"></a>

## 初期設定

ロケールなどを設定

<a id="markdown-ウィザードで設定する場合" name="ウィザードで設定する場合"></a>

### ウィザードで設定する場合

```sh
$ sudo raspi-config
```

<a id="markdown-コマンドで設定する場合" name="コマンドで設定する場合"></a>

### コマンドで設定する場合

```sh
# ホスト名
$ sudo raspi-config nonint do_hostname NEW_HOSTNAME

# ロケール等
$ sudo raspi-config nonint do_change_locale ja_JP.UTF-8
$ sudo raspi-config nonint do_change_timezone Asia/Tokyo
$ sudo raspi-config nonint do_configure_keyboard jp
$ sudo raspi-config nonint do_wifi_country JP

# 解像度
$ sudo raspi-config nonint do_resolution 800 600

# I2C ON
sudo raspi-config nonint do_i2c 0
# I2C OFF
sudo raspi-config nonint do_i2c 1

# カメラ ON
$ sudo raspi-config nonint do_camera 0
# カメラ OFF
$ sudo raspi-config nonint do_camera 1

# VNC ON
$ sudo raspi-config nonint do_vnc 0
# VNC OFF
$ sudo raspi-config nonint do_vnc 1
```

<a id="markdown-ip-アドレスを固定" name="ip-アドレスを固定"></a>

## IP アドレスを固定

```sh
$ sudo nano /etc/dhcpcd.conf
```

```
# Example static IP configuration:
interface eth0
static ip_address=固定IPアドレス/24
static routers=デフォルトゲートウェイのIPアドレス
static domain_name_servers=DNSサーバーのIPアドレス
```

```sh
$ sudo ifconfig eth0 down
$ sudo ifconfig eth0 up
```
