cat rock.json | jq -c '.docs[] | {_id: .id, name, tags, similar, tracks}' > rock-mongo.json
