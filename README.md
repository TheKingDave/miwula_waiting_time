Stores the current waiting time of the [Miniatur Wunderland](https://www.miniatur-wunderland.com/) time in InfluxDB

## Running

Docker:

`docker run --env-file .env thekingdave/miwula_waiting_time`

Docker Compose:

```yaml
version: '3.9'

services:
  miwula_waiting_time:
    image: thekingdave/miwula_waiting_time:latest
    # Only need one of env_file or environment, or a combination
    env_file: .env
    environment:
      - RESOLUTION: 60
      - INFLUX_URL: "http://influx:8086"
      - INFLUX_TOKEN: "<your token here>"
      - INFlUX_ORG: "<your org>"
      - INFLUX_BUCKET: "<your bucket>"

  influx:
    image: influxdb:alpine
    ports:
      - "8086:8086"
    volumes:
      - ./data:/var/lib/influxdb2
```

## Config
See example configuration under [example.env](./example.env)

| ENV           | Description                          | Default               |
|---------------|--------------------------------------|-----------------------|
| RESOLUTION    | How often the waiting time is polled | 60                    |
| INFLUX_URL    | The url to the InfluxDB              | http://localhost:8086 |
| INFLUX_TOKEN  | The token to authenticate            | -                     |
| INFlUX_ORG    | The organization to us               | -                     |
| INFLUX_BUCKET | The bucket to use                    | -                     |