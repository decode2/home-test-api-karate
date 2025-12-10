# Inventory API Test - Karate Framework

This repository contains the SDET technical test solution, implemented using **Java 17** and **Karate DSL**.

## Tech Stack

* **Language:** Java 17 (LTS)
* **Framework:** Karate 1.4.1
* **Build Tool:** Maven

## Environment Setup (Troubleshooting)

**Important:** The provided Docker image (`automaticbytes/demo-app`) targets `linux/arm64` architecture.
To run this project on a standard **Windows/Linux (AMD64)** machine, I enabled QEMU emulation.

**1. Enable Emulation (Run once):**
```bash
docker run --privileged --rm tonistiigi/binfmt --install all