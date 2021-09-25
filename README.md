# pad

## Attivare il display

```
sudo nc -lkU /dev/pad1
```

## Stampare sul display

```
echo "Hello, World!" | sudo nc -q0 -U /dev/pad1
```

