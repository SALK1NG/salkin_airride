# 🚗 salkin_airride

![FiveM](https://img.shields.io/badge/FiveM-Ready-orange)
![ESX](https://img.shields.io/badge/Framework-ESX-red)
![ox\_inventory](https://img.shields.io/badge/Inventory-ox_inventory-blue)
![oxmysql](https://img.shields.io/badge/Database-oxmysql-green)
![License](https://img.shields.io/badge/License-Free-lightgrey)

> Advanced Airride System for ESX Servers
> Realistische Luftfahrwerk-Steuerung mit Besitzprüfung, Synchronisation und Speed-Limit.

![Showcase](https://postimg.cc/gallery/bJYNHZs)

---

## ✨ Features

* 🚘 Installation per Item (`ox_inventory`)
* 🔐 Fahrzeug-Besitzprüfung (Datenbank)
* 📦 Speicherung in `owned_vehicles`
* 🎛️ Live Höhenverstellung
* 🌍 Synchronisiert für alle Spieler
* 🚦 Automatische Geschwindigkeitsbegrenzung bei maximaler Tiefe
* 🧱 Starre Federung im „Show-Modus“
* 🔧 Mechaniker-Tuning kompatibel
* ⚙️ Fahrzeug-Whitelist mit individuellen Limits

---

## 📋 Requirements

* [es_extended (ESX)](https://github.com/esx-framework/esx_core)
* [ox_inventory](https://github.com/overextended/ox_inventory)
* [oxmysql](https://github.com/overextended/oxmysql)
* ox_lib

---

## 🗄️ Datenbank Setup

Füge folgende Spalte deiner `owned_vehicles` Tabelle hinzu:

```sql
ALTER TABLE owned_vehicles ADD COLUMN airride TINYINT(1) DEFAULT 0;
```

---

## 🎒 ox_inventory Item

Füge das Item in `ox_inventory/data/items.lua` ein:

```lua
['airride_kit'] = {
    label = 'Airride Einbausatz',
    weight = 5000,
    stack = true,
    close = true,
    description = 'Ein komplettes Luftfahrwerk-Set zum Einbauen.',
    client = {
        export = 'salkin_airride.installAirride'
    }
},
```

---

## 🚀 Installation

1. Repository herunterladen
2. In deinen `resources` Ordner legen
3. In `server.cfg` eintragen:

```
ensure salkin_airride
```

4. Datenbank-Spalte hinzufügen
5. Item in ox_inventory einfügen
6. Server neu starten

---

## 🎮 Steuerung

Standardmäßig:

| Aktion | Taste        |
| ------ | ------------ |
| Hoch   | Pfeil Hoch   |
| Runter | Pfeil Runter |

Konfigurierbar in:

```lua
Config.Controls = {
    Up = 172,
    Down = 173,
}
```

---

## ⚙️ Konfiguration

### Grundwerte

```lua
Config.ItemName = "airride_kit"
Config.InstallTime = 5000
Config.ChangeSpeed = 0.001
Config.StiffSuspensionForce = 100.0
Config.TuningReductionFactor = 0.02
```

---

### Fahrzeug-Whitelist

```lua
Config.VehicleWhitelist = {
    ['sultan'] = { min = 0.0, max = 0.10 },
    ['baller'] = { min = 0.0, max = 0.13 },
}
```

| Parameter | Beschreibung |
| --------- | ------------ |
| `min`     | Minimalhöhe  |
| `max`     | Maximalhöhe  |

---

## 🔧 Mechaniker-Tuning Support

Das Script berücksichtigt Tuning-Stufen:

```lua
Config.TuningReductionFactor = 0.02
```

Pro Tuning-Stufe wird die maximale Tiefe reduziert, um Bodenkollisionen zu vermeiden.

---

## 🔄 Events & Callbacks

### Server Callbacks

* `salkin_airride:server:hasAirrideInstalled`
* `salkin_airride:server:isOwner`

### Server Events

* `salkin_airride:server:installSuccess`
* `salkin_airride:server:syncHeight`

### Client Events

* `salkin_airride:client:applyHeight`

---

## 🔐 Sicherheit

* ✅ Besitzerprüfung via Identifier
* ✅ Item-Entfernung serverseitig
* ✅ Datenbank-Validierung
* ✅ Synchronisation über NetID

---

## 🧠 Ablauf

1. Spieler nutzt Airride Kit
2. Besitzprüfung
3. Progressbar
4. Item wird entfernt
5. DB wird aktualisiert
6. Airride aktiv
7. Live Höhensteuerung
8. Sync an alle Spieler

---

## 🛠️ Kompatibilität

* Funktioniert nur mit `owned_vehicles`
* Nicht kompatibel mit Scripts, die permanent Handling-Werte überschreiben
* Unterstützt ESX Standard Notifications

---

## 📌 Roadmap (optional)

* [ ] UI Anzeige für aktuelle Höhe
* [ ] Show-Modus Animation
* [ ] Soundeffekte
* [ ] Admin Debug Command

---

## 📄 License

Free to use & modify.
Credits appreciated ❤️

---
Wenn du möchtest, kann ich dir noch:

* 🔥 eine **professionelle Premium-README Version**
* 🌍 eine **DE/EN Dual Language Version**
* 🖼️ mit **Preview GIF Abschnitt**
* 🧩 mit **fxmanifest Beispiel**
* oder eine **Release-Struktur für Tebex**
