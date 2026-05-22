# Hero UI Flutter

**Hero UI Flutter** (`hero_ui_flutter`) è un porting Flutter del design system [HeroUI](https://heroui.com/) (precedentemente NextUI). L'obiettivo è riprodurre al meglio l'estetica, i token di tema e l'API dei componenti HeroUI v3, adattandoli alle convenzioni e al runtime Flutter/Material.

> HeroUI originale: [heroui.com](https://heroui.com/) · [GitHub heroui-inc/heroui](https://github.com/heroui-inc/heroui)

Questa libreria **non è affiliata ufficilmente** con HeroUI Inc. È un progetto indipendente ispirato al loro design system open source.

---

## Indice

- [Perché questa libreria](#perché-questa-libreria)
- [Installazione](#installazione)
- [Avvio rapido](#avvio-rapido)
- [Sistema di temi](#sistema-di-temi)
- [Componenti](#componenti)
  - [HUFButton](#hufbutton)
  - [HUFButtonGroup](#hufbuttongroup)
  - [HUFChip](#hufchip)
  - [HUFCard](#hufcard)
  - [HUFAccordion](#hufaccordion)
  - [HUFAlert](#hufalert)
  - [HUFAlertDialog](#hufalertdialog)
  - [HUFToast](#huftoast)
  - [HUFDrawer](#hufdrawer)
  - [HUFAvatar](#hufavatar)
  - [HUFCheckbox](#hufcheckbox)
  - [HUFCheckboxGroup](#hufcheckboxgroup)
  - [HUFCheckboxCard](#hufcheckboxcard)
  - [HUFCheckboxCardGroup](#hufcheckboxcardgroup)
  - [HUFRadioButton](#hufradiobutton)
  - [HUFRadioButtonGroup](#hufradiobuttongroup)
  - [HUFSwitch](#hufswitch)
  - [HUFSwitchGroup](#hufswitchgroup)
  - [HUFSlider](#hufslider)
  - [HUFRangeSlider](#hufrangeslider)
  - [HUFPopover](#hufpopover)
  - [HUFInput](#hufinput)
  - [HUFSelect](#hufselect)
  - [HUFSeparator](#hufseparator)
- [Roadmap componenti](#roadmap-componenti)
- [App di esempio](#app-di-esempio)
- [Licenza](#licenza)

---

## Perché questa libreria

[HeroUI](https://heroui.com/) è una libreria UI moderna per React/Next.js, costruita su React Aria e Tailwind CSS v4. Offre componenti accessibili, un design system coerente e preset di tema pronti all'uso.

**Hero UI Flutter** porta lo stesso linguaggio visivo su Flutter:

- Token colore allineati a `@heroui/styles` (OKLCH convertiti in `Color`)
- Preset tema identici (Sky, Spotify, Coinbase, …)
- Border radius e glow condivisi tra tutti i componenti
- API widget Flutter-native con prefisso `HUF` (*Hero UI Flutter*)
- Supporto light/dark out of the box

---

## Installazione

Aggiungi la dipendenza al `pubspec.yaml` del tuo progetto:

```yaml
dependencies:
  hero_ui_flutter:
    path: ../hero_ui_flutter   # oppure da pub.dev quando pubblicato
```

Poi esegui:

```bash
flutter pub get
```

**Requisiti:** Dart SDK `^3.11.5`, Flutter `>=1.17.0`.

---

## Avvio rapido

Importa il package e configura il tema nell'app:

```dart
import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const themeData = HUFThemeData(theme: HUFThemePreset.sky);

    return MaterialApp(
      title: 'Hero UI Flutter',
      theme: HUFTheme.light(data: themeData).toThemeData(),
      darkTheme: HUFTheme.dark(data: themeData).toThemeData(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero UI Flutter')),
      body: Center(
        child: HUFButton(
          label: 'Clicca qui',
          variant: HUFButtonVariant.primary,
          onPressed: () {},
        ),
      ),
    );
  }
}
```

### Accesso al tema dal contesto

Ogni componente legge automaticamente il tema registrato in `MaterialApp`:

```dart
final theme = context.hufTheme;          // oppure HUFTheme.of(context)
final colors = theme.colors;
final radius = theme.borderRadius.value;
```

---

## Sistema di temi

Il sistema di temi è modulare e segue la stessa gerarchia concettuale di HeroUI.

### `HUFTheme`

Estensione di `ThemeExtension<HUFTheme>` che aggrega:


| Proprietà      | Tipo              | Descrizione                            |
| -------------- | ----------------- | -------------------------------------- |
| `brightness`   | `Brightness`      | Modalità chiara o scura                |
| `colors`       | `HUFThemeColors`  | Token colore semantici                 |
| `borderRadius` | `HUFBorderRadius` | Radius condiviso da tutti i componenti |
| `glowSize`     | `HUFGlowSize`     | Intensità dell'ombra glow              |


**Factory:**

- `HUFTheme.light({ data, colors, borderRadius, glowSize })`
- `HUFTheme.dark({ data, colors, borderRadius, glowSize })`
- `HUFTheme.fromData(data, brightness: …)`

**Metodi utili:**

- `toThemeData({ base })` — produce un `ThemeData` Material con l'estensione HUF collegata
- `HUFTheme.of(context)` — recupera il tema dal contesto (fallback su light)

### `HUFThemeData`

Configurazione completa del tema. Permette preset, override per modalità e token globali.


| Proprietà      | Tipo               | Descrizione                                    |
| -------------- | ------------------ | ---------------------------------------------- |
| `theme`        | `HUFThemePreset?`  | Preset built-in (es. `HUFThemePreset.spotify`) |
| `light`        | `HUFThemePalette?` | Override palette modalità chiara               |
| `dark`         | `HUFThemePalette?` | Override palette modalità scura                |
| `borderRadius` | `HUFBorderRadius?` | Radius globale                                 |
| `glowSize`     | `HUFGlowSize?`     | Glow globale                                   |


**Shortcut:**

```dart
const HUFThemeData(theme: HUFThemePreset.coinbase)
const HUFThemeData.preset(HUFThemePreset.mint)
HUFThemeData.shared(colors: customColors, borderRadius: HUFBorderRadius.large)
```

### `HUFThemeColors`

Token colore semantici, allineati a HeroUI:


| Token                                                                 | Uso                      |
| --------------------------------------------------------------------- | ------------------------ |
| `background`                                                          | Sfondo pagina            |
| `border`                                                              | Bordi neutri             |
| `primary` / `primaryForeground`                                       | Colore accent principale |
| `secondary` / `secondaryForeground`                                   | Colore secondario        |
| `danger` / `dangerForeground` / `dangerSoft` / `dangerSoftForeground` | Stati di errore          |
| `success` / `successForeground`                                       | Stati di successo        |
| `warning` / `warningForeground`                                       | Avvisi                   |
| `disabled` / `disabledForeground`                                     | Stati disabilitati       |
| `card` / `cardSecondary` / `cardTertiary`                             | Sfondi card              |
| `cardForeground` / `cardMutedForeground`                              | Testo su card            |
| `transparent`                                                         | Trasparente              |


Valori predefiniti: `HUFThemeColors.light` e `HUFThemeColors.dark`.

### `HUFThemePreset`

Preset colore convertiti da `@heroui/styles`:


| Preset         | Note                              |
| -------------- | --------------------------------- |
| `defaultTheme` | Design system predefinito         |
| `sky`          | Azzurro/cyan                      |
| `lavender`     | Viola pastello                    |
| `mint`         | Verde menta                       |
| `netflix`      | Rosso Netflix, radius extra-small |
| `uber`         | Monocromatico, radius small       |
| `spotify`      | Verde Spotify                     |
| `coinbase`     | Blu Coinbase                      |
| `airbnb`       | Rosa Airbnb                       |
| `discord`      | Viola Discord, radius small       |
| `rabbit`       | Arancio/terracotta                |


### `HUFBorderRadius`

Radius condiviso tra card, bottoni, input e altri componenti.


| Costante     | Valore       |
| ------------ | ------------ |
| `none`       | 0            |
| `extraSmall` | 2            |
| `small`      | 4            |
| `medium`     | 12 (default) |
| `large`      | 16           |


Proprietà: `value` (radius standard), `full` (999, per elementi pill/circolari).

### `HUFGlowSize`

Intensità dell'ombra glow su bottoni, checkbox, radio, switch:

`none` · `small` · `medium` · `large`

---

### Esempi di personalizzazione

**Preset + override radius:**

```dart
const themeData = HUFThemeData(
  theme: HUFThemePreset.coinbase,
  borderRadius: HUFBorderRadius.large,
);
```

**Tema brand custom:**

```dart
class MyBrandTheme extends HUFThemeData {
  const MyBrandTheme()
      : super(
          light: HUFThemePalette(
            colors: HUFThemeColors.light.copyWith(
              primary: Color(0xFF0052FF),
            ),
          ),
          dark: HUFThemePalette(
            colors: HUFThemeColors.dark.copyWith(
              primary: Color(0xFF0052FF),
            ),
          ),
        );
}
```

**Tema dinamico (es. switch light/dark):**

```dart
MaterialApp(
  themeMode: _themeMode,
  theme: HUFTheme.light(data: themeData).toThemeData(),
  darkTheme: HUFTheme.dark(data: themeData).toThemeData(),
  // ...
)
```

---

## Componenti

Tutti i widget usano il prefisso `**HUF**` e leggono automaticamente `context.hufTheme`.

### HUFButton

Pulsante del design system con varianti, dimensioni, glow e stato loading.

```dart
HUFButton(
  label: 'Salva',
  variant: HUFButtonVariant.primary,
  size: HUFButtonSize.medium,
  icon: Icon(Icons.save),
  isLoading: false,
  isFullWidth: false,
  glowSize: HUFGlowSize.medium,
  onPressed: () {},
)

// Solo icona
HUFButton.iconOnly(
  icon: Icon(Icons.add),
  variant: HUFButtonVariant.outlined,
  onPressed: () {},
)

// Con popover (il tap apre/chiude; onPressed non viene invocato)
HUFButton(
  label: 'Opzioni',
  variant: HUFButtonVariant.outlined,
  popover: HUFButtonPopover(
    showArrow: true,
    child: HUFPopoverContent(
      title: 'Impostazioni',
      description: 'Contenuto del popover.',
    ),
  ),
)
```


| Proprietà     | Tipo               | Default   | Descrizione                           |
| ------------- | ------------------ | --------- | ------------------------------------- |
| `label`       | `String`           | —         | Testo del pulsante                    |
| `onPressed`   | `VoidCallback?`    | `null`    | Callback al tap; `null` disabilita    |
| `variant`     | `HUFButtonVariant` | `primary` | Stile visivo                          |
| `size`        | `HUFButtonSize`    | `medium`  | Dimensione                            |
| `isLoading`   | `bool`             | `false`   | Mostra spinner al posto dell'icona    |
| `isFullWidth` | `bool`             | `false`   | Occupa tutta la larghezza disponibile |
| `icon`        | `Widget?`          | `null`    | Icona opzionale a sinistra del testo  |
| `glowSize`    | `HUFGlowSize?`     | tema      | Override intensità glow               |
| `popover`     | `HUFButtonPopover?`| `null`    | Popover ancorato al tap del pulsante  |


**Varianti:** `primary` · `secondary` · `outlined` · `ghost` · `danger` · `dangerSoft`

**Dimensioni:** `small` · `medium` · `large`

---

### HUFButtonGroup

Gruppo di pulsanti affiancati con aspetto di un unico controllo segmentato.

```dart
HUFButtonGroup(
  variant: HUFButtonVariant.outlined,
  size: HUFButtonSize.medium,
  items: [
    HUFButtonGroupItem(label: 'Giorno', onPressed: () {}),
    HUFButtonGroupItem(label: 'Settimana', onPressed: () {}),
    HUFButtonGroupItem(label: 'Mese', onPressed: () {}),
  ],
)
```


| Proprietà  | Tipo                       | Default   | Descrizione          |
| ---------- | -------------------------- | --------- | -------------------- |
| `items`    | `List<HUFButtonGroupItem>` | —         | Almeno 2 elementi    |
| `variant`  | `HUFButtonVariant`         | `primary` | Variante condivisa   |
| `size`     | `HUFButtonSize`            | `medium`  | Dimensione condivisa |
| `glowSize` | `HUFGlowSize?`             | tema      | Override glow        |


`**HUFButtonGroupItem`:** `label`, `icon`, `onPressed`.

---

### HUFChip

Etichetta compatta non interattiva per tag, badge o label.

```dart
HUFChip(
  label: 'Nuovo',
  variant: HUFChipVariant.primary,
  size: HUFChipSize.small,
  icon: Icon(Icons.star, size: 14),
  isDisabled: false,
)
```


| Proprietà    | Tipo             | Default   | Descrizione                      |
| ------------ | ---------------- | --------- | -------------------------------- |
| `label`      | `String`         | —         | Testo                            |
| `variant`    | `HUFChipVariant` | `primary` | `primary` · `outlined` · `ghost` |
| `size`       | `HUFChipSize`    | `medium`  | `small` · `medium` · `large`     |
| `icon`       | `Widget?`        | `null`    | Icona opzionale                  |
| `isDisabled` | `bool`           | `false`   | Stile attenuato                  |


---

### HUFCard

Card composable con immagine, titolo, sottotitolo, contenuto custom e azioni.

```dart
HUFCard(
  style: HUFCardStyle.card,
  orientation: HUFCardOrientation.vertical,
  radiusSize: HUFCardRadiusSize.medium,
  image: Image.network('https://…'),
  imageAspectRatio: 16 / 9,
  title: 'Titolo card',
  subtitle: 'Sottotitolo descrittivo',
  content: Text('Contenuto libero'),
  actions: [
    HUFButton(label: 'Annulla', variant: HUFButtonVariant.ghost, onPressed: () {}),
    HUFButton(label: 'Conferma', onPressed: () {}),
  ],
  actionsLayout: HUFCardActionsLayout.row,
  onTap: () {},
)
```


| Proprietà          | Tipo                   | Default    | Descrizione                                               |
| ------------------ | ---------------------- | ---------- | --------------------------------------------------------- |
| `style`            | `HUFCardStyle`         | `card`     | `transparent` · `card` · `cardSecondary` · `cardTertiary` |
| `orientation`      | `HUFCardOrientation`   | `vertical` | `vertical` · `horizontal`                                 |
| `radiusSize`       | `HUFCardRadiusSize`    | `medium`   | Scala tipografica titolo/sottotitolo                      |
| `image`            | `Widget?`              | `null`     | Widget immagine                                           |
| `imageAspectRatio` | `double?`              | `16/9`     | Aspect ratio in layout verticale                          |
| `title`            | `String?`              | `null`     | Titolo                                                    |
| `subtitle`         | `String?`              | `null`     | Sottotitolo                                               |
| `content`          | `Widget?`              | `null`     | Contenuto custom                                          |
| `actions`          | `List<Widget>`         | `[]`       | Azioni (es. `HUFButton`)                                  |
| `actionsLayout`    | `HUFCardActionsLayout` | `row`      | `row` · `stacked`                                         |
| `onTap`            | `VoidCallback?`        | `null`     | Rende la card cliccabile                                  |


Helper `hufCardExpandAction(action)` espande un `HUFButton` a tutta la larghezza nelle azioni.

---

### HUFAccordion

Lista espandibile con item singoli o gruppo gestito. Variante `card` (contenitore con bordo) o `ghost` (trasparente).

**Item singolo:**

```dart
HUFAccordionItem(
  title: 'Domanda frequente',
  content: Text('Risposta dettagliata…'),
  isExpanded: _open,
  onExpansionChanged: (v) => setState(() => _open = v),
  leading: Icon(Icons.help_outline),
)
```

**Gruppo:**

```dart
HUFAccordion<String>(
  variant: HUFAccordionVariant.card,
  allowMultiple: true,
  showSeparators: true,
  initialExpanded: {'faq1'},
  onExpansionChanged: (values) {},
  children: [
    HUFAccordionItem(
      optionValue: 'faq1',
      title: 'Come funziona?',
      content: Text('…'),
    ),
    HUFAccordionItem(
      optionValue: 'faq2',
      title: 'Prezzi',
      content: Text('…'),
    ),
  ],
)
```


| Proprietà (`HUFAccordion`)    | Tipo                     | Default | Descrizione                           |
| ----------------------------- | ------------------------ | ------- | ------------------------------------- |
| `children`                    | `List<HUFAccordionItem>` | —       | Almeno un item con `optionValue`      |
| `variant`                     | `HUFAccordionVariant`    | `card`  | `ghost` · `card`                      |
| `showSeparators`              | `bool`                   | `true`  | Separatori tra item                   |
| `allowMultiple`               | `bool`                   | `true`  | Più item aperti; se `false`, uno solo |
| `initialExpanded`             | `Set<T>?`                | `{}`    | Valori iniziali (non controllato)     |
| `expanded`                    | `Set<T>?`                | —       | Valori correnti (controllato)         |
| `onExpansionChanged`          | `ValueChanged<Set<T>>?`  | —       | Notifica cambiamenti                  |
| `expandIcon` / `collapseIcon` | `Widget?`                | freccia | Icone condivise per tutti gli item    |
| `titleColor` / `iconColor`    | `Color?`                 | tema    | Override colori                       |



| Proprietà (`HUFAccordionItem`) | Tipo                  | Default | Descrizione                 |
| ------------------------------ | --------------------- | ------- | --------------------------- |
| `title`                        | `String`              | —       | Titolo nell'header          |
| `content`                      | `Widget?`             | `null`  | Contenuto espandibile       |
| `leading`                      | `Widget?`             | `null`  | Icona a sinistra del titolo |
| `optionValue`                  | `Object?`             | —       | ID opzione (uso in gruppo)  |
| `isExpanded`                   | `bool?`               | —       | Stato (uso singolo)         |
| `onExpansionChanged`           | `ValueChanged<bool>?` | —       | Callback (uso singolo)      |
| `enabled`                      | `bool`                | `true`  | Abilita il tap sull'header  |


---

### HUFAlert

Alert orizzontale con icona, titolo, descrizione, azione o pulsante di chiusura. Colori di accento semantici; sfondo e testo descrittivo seguono i token card del tema.

```dart
HUFAlert(
  icon: Icon(Icons.info_outline),
  title: 'Aggiornamento disponibile',
  description: 'È disponibile una nuova versione dell\'app.',
  color: HUFAlertColor.accent,
  size: HUFAlertSize.medium,
  action: HUFAlertAction(label: 'Aggiorna', onPressed: () {}),
  showCloseButton: true,
  onDismiss: () {},
)
```


| Proprietà         | Tipo              | Default        | Descrizione                                                  |
| ----------------- | ----------------- | -------------- | ------------------------------------------------------------ |
| `leading`         | `Widget?`         | `null`         | Widget a sinistra; priorità su `icon`                        |
| `icon`            | `Widget?`         | `null`         | Icona di stato                                               |
| `isLoading`       | `bool`            | `false`        | Spinner al posto dell'icona                                  |
| `title`           | `String?`         | `null`         | Titolo                                                       |
| `description`     | `String?`         | `null`         | Testo descrittivo                                            |
| `content`         | `Widget?`         | `null`         | Contenuto custom sotto il titolo                             |
| `action`          | `HUFAlertAction?` | `null`         | Pulsante pill a destra                                       |
| `trailing`        | `Widget?`         | `null`         | Trailing custom; priorità su `action`                        |
| `showCloseButton` | `bool`            | `false`        | Pulsante chiusura se `action` e `trailing` sono null         |
| `onDismiss`       | `VoidCallback?`   | —              | Callback del pulsante chiusura                               |
| `color`           | `HUFAlertColor`   | `defaultColor` | `defaultColor` · `accent` · `success` · `warning` · `danger` |
| `size`            | `HUFAlertSize`    | `medium`       | `small` · `medium` · `large`                                 |


`**HUFAlertAction`:** `label`, `onPressed`.

#### Alert in overlay (toast-like)

Per mostrare alert negli angoli dello schermo, avvolgi l'app con `HUFAlertOverlay` e usa `hufShowAlert` o l'estensione `showHufAlert`:

```dart
MaterialApp(
  builder: (context, child) => HUFAlertOverlay(child: child!),
  // ...
);

// Mostra alert temporaneo
final id = context.showHufAlert(
  options: HUFShowAlertOptions(
    position: HUFAlertPosition.topRight,
    duration: const Duration(seconds: 4),
    title: 'Salvato',
    description: 'Le modifiche sono state applicate.',
    showCloseButton: true,
    color: HUFAlertColor.success,
  ),
);

context.dismissHufAlert(id);
context.dismissAllHufAlerts();
```


| `HUFShowAlertOptions` | Tipo               | Default    | Descrizione                                           |
| --------------------- | ------------------ | ---------- | ----------------------------------------------------- |
| `position`            | `HUFAlertPosition` | `topRight` | `topLeft` · `topRight` · `bottomLeft` · `bottomRight` |
| `margin`              | `EdgeInsets`       | `16`       | Margine dall'angolo                                   |
| `duration`            | `Duration?`        | `null`     | Auto-dismiss; `null` = persistente                    |
| `onDismissed`         | `VoidCallback?`    | —          | Dopo rimozione dall'overlay                           |


Le altre proprietà di `HUFShowAlertOptions` corrispondono a quelle di `HUFAlert`.

---

### HUFAlertDialog

Dialog modale con icona di stato, titolo, descrizione o contenuto custom, overlay scuro e pulsante di chiusura icon-only obbligatorio. Colori di superficie e testo seguono [HUFTheme]; l'icona usa il colore semantico [HUFAlertColor]. Le azioni nel footer sono opzionali (max 2) e vanno passate esplicitamente come [HUFButton] o altri widget.

```dart
await context.showHufAlertDialog(
  options: HUFShowAlertDialogOptions(
    icon: const Icon(Icons.error_outline),
    color: HUFAlertColor.danger,
    title: 'Delete project permanently?',
    description: 'This action cannot be undone.',
    actions: [
      HUFButton(
        label: 'Cancel',
        variant: HUFButtonVariant.secondary,
        onPressed: () => Navigator.of(context).pop(),
      ),
      HUFButton(
        label: 'Delete Project',
        variant: HUFButtonVariant.danger,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);
```

| Proprietà       | Tipo                | Default        | Descrizione                                                                 |
| --------------- | ------------------- | -------------- | --------------------------------------------------------------------------- |
| `leading`       | `Widget?`           | `null`         | Widget in alto a sinistra; priorità su `icon`                               |
| `icon`          | `Widget?`           | `null`         | Icona di stato nel cerchio semitrasparente                                  |
| `isLoading`     | `bool`              | `false`        | Spinner al posto dell'icona                                                 |
| `title`         | `String?`           | `null`         | Titolo                                                                      |
| `description`   | `String?`           | `null`         | Testo descrittivo                                                           |
| `content`       | `Widget?`           | `null`         | Contenuto custom sotto il titolo                                            |
| `actions`       | `List<Widget>`      | `[]`           | Fino a 2 azioni (es. [HUFButton]); nessun default                           |
| `onDismiss`     | `VoidCallback`      | —              | Callback del pulsante chiusura (obbligatorio)                               |
| `color`         | `HUFAlertColor`     | `defaultColor` | Colore semantico dell'icona di stato                                        |

**Layout azioni:** senza [HUFButton.isFullWidth] sono allineate a destra; una sola azione full-width occupa tutta la riga; due azioni full-width si dividono il 50% ciascuna.

#### Mostrare il dialog modale

`hufShowAlertDialog` / `showHufAlertDialog` usano overlay scuro e fade (~200 ms). Posizione predefinita: centro; override con `position`: `center` · `top` · `bottom`.

| `HUFShowAlertDialogOptions` | Tipo                     | Default    | Descrizione                          |
| --------------------------- | ------------------------ | ---------- | ------------------------------------ |
| `position`                  | `HUFAlertDialogPosition` | `center`   | `center` · `top` · `bottom`          |
| `barrierDismissible`        | `bool`                   | `false`    | Tap sull'overlay per chiudere        |
| `barrierColor`              | `Color?`                 | scrim scuro| Colore overlay                       |
| `onDismissed`               | `VoidCallback?`          | —          | Dopo chiusura (X o pop)              |

Le altre proprietà corrispondono a [HUFAlertDialog]. È possibile passare un `HUFAlertDialog` già costruito al posto di `options`.

---

### HUFToast

Toast orizzontale a pill con [title] obbligatorio, [description] opzionale, icona opzionale e azione pill opzionale. Sfondo e descrizione seguono [HUFTheme]; con un [HUFAlertColor] semantico, icona e titolo usano quel colore (l'azione pill usa lo stesso accento come sfondo).

```dart
context.showHufToast(
  options: HUFShowToastOptions(
    position: HUFToastPosition.bottomCenter,
    durationSeconds: 5,
    icon: const Icon(Icons.check_circle_outline),
    color: HUFAlertColor.success,
    title: 'You have upgraded your plan',
    description: 'You can continue using HeroUI Chat',
    action: HUFToastAction(label: 'Billing', onPressed: () {}),
  ),
);
```

| Proprietà       | Tipo              | Default        | Descrizione                                      |
| --------------- | ----------------- | -------------- | ------------------------------------------------ |
| `title`         | `String`          | —              | Titolo (obbligatorio)                            |
| `leading`       | `Widget?`         | `null`         | Widget a sinistra; priorità su `icon`            |
| `icon`          | `Widget?`         | `null`         | Icona di stato                                   |
| `isLoading`     | `bool`            | `false`        | Spinner al posto dell'icona                      |
| `description`   | `String?`         | `null`         | Testo sotto il titolo                            |
| `action`        | `HUFToastAction?` | `null`         | Pulsante pill a destra                           |
| `trailing`      | `Widget?`         | `null`         | Trailing custom; priorità su `action`            |
| `color`         | `HUFAlertColor`   | `defaultColor` | Colore semantico per icona e titolo              |

#### Toast in overlay

Avvolgi l'app con `HUFToastOverlay` e usa `hufShowToast` o `showHufToast`:

```dart
MaterialApp(
  builder: (context, child) => HUFToastOverlay(
    child: HUFAlertOverlay(child: child!),
  ),
);

final id = context.showHufToast(
  options: HUFShowToastOptions(
    position: HUFToastPosition.topCenter,
    durationSeconds: 4,
    title: 'Salvato',
    color: HUFAlertColor.success,
  ),
);

context.dismissHufToast(id);
```

| `HUFShowToastOptions` | Tipo               | Default          | Descrizione                                           |
| --------------------- | ------------------ | ---------------- | ----------------------------------------------------- |
| `position`            | `HUFToastPosition` | `bottomCenter`   | `topCenter` (slide dall'alto) · `bottomCenter` (dal basso) |
| `durationSeconds`     | `double?`          | `null`           | Secondi prima della scomparsa con fade; `null` = persistente |
| `margin`              | `EdgeInsets`       | `16`             | Margine dal bordo sicuro                              |
| `onDismissed`         | `VoidCallback?`    | —                | Dopo rimozione dall'overlay                           |

Le altre proprietà corrispondono a [HUFToast].

---

### HUFDrawer

Pannello laterale o dal basso con sfondo [HUFThemeColors.card]. [content] è una lista di widget impilati in colonna.

- **Classico** (`isFullWidth: false`): overlay scuro; tap fuori dal pannello chiude.
- **Full width** (`isFullWidth: true`): larghezza/altezza piena; chiusura solo con pulsante icon-only (X) in alto a destra.
- **Dal basso (default)**: larghezza piena, altezza dal contenuto (tetto ~55% schermo).
- **Dal basso + `height`**: altezza fissa in px.
- **Dal basso + `isFullWidth`**: schermo intero, solo X.

```dart
// Imperativo
context.showHufDrawer(
  options: HUFShowDrawerOptions(
    openFrom: HUFDrawerOpenFrom.left,
    width: 320, // larghezza fissa (solo se isFullWidth è false)
    content: [
      Text('Menu'),
      HUFButton(label: 'Profilo', onPressed: () {}),
    ],
  ),
);

// In Stack
Stack(
  children: [
    body,
    HUFDrawer(
      isOpen: isOpen,
      onClose: () => setState(() => isOpen = false),
      openFrom: HUFDrawerOpenFrom.right,
      content: [...],
    ),
  ],
);
```

| Proprietà       | Tipo                 | Default  | Descrizione                                      |
| --------------- | -------------------- | -------- | ------------------------------------------------ |
| `isOpen`        | `bool`               | —        | Visibilità ([HUFDrawer] in Stack)                  |
| `onClose`       | `VoidCallback`       | —        | Callback chiusura                                |
| `openFrom`      | `HUFDrawerOpenFrom`  | `left`   | `left` · `right` · `bottom`                      |
| `isFullWidth`   | `bool`               | `false`  | Pannello a tutto schermo + pulsante X            |
| `content`       | `List<Widget>`       | `[]`     | Contenuto impilato verticalmente                 |
| `width`         | `double?`            | `null`   | Larghezza fissa laterale (`left`/`right`); ignorata se `isFullWidth` |
| `height`        | `double?`            | `null`   | Altezza fissa (`bottom`); se `null` dal basso segue il contenuto     |
| `barrierColor`  | `Color?`             | scrim    | Colore overlay                                   |

---

### HUFAvatar

Avatar circolare con immagine, iniziali (max 2 caratteri) o icona di fallback. Supporta anello, badge e gruppi sovrapposti.

```dart
HUFAvatar(
  size: HUFAvatarSize.medium,
  color: HUFAvatarColor.accent,
  variant: HUFAvatarVariant.soft,
  image: NetworkImage('https://…'),
  ringWidth: 2,
  badge: HUFAvatarBadge.count(3),
)

// Fallback con iniziali
HUFAvatar(
  initials: 'MP',
  color: HUFAvatarColor.defaultColor,
)

// Badge dot, icona o etichetta
HUFAvatar(
  icon: Icon(Icons.person),
  badge: HUFAvatarBadge.dot(color: HUFAvatarBadgeColor.success),
)
```


| Proprietà                 | Tipo                | Default          | Descrizione                      |
| ------------------------- | ------------------- | ---------------- | -------------------------------- |
| `size`                    | `HUFAvatarSize`     | `medium`         | `small` · `medium` · `large`     |
| `color`                   | `HUFAvatarColor`    | `defaultColor`   | Colore fallback semantico        |
| `variant`                 | `HUFAvatarVariant`  | `defaultVariant` | `defaultVariant` · `soft`        |
| `image`                   | `ImageProvider?`    | `null`           | Immagine (priorità su fallback)  |
| `initials`                | `String?`           | `null`           | Fino a 2 lettere                 |
| `icon`                    | `Widget?`           | `null`           | Icona se manca immagine/iniziali |
| `ringWidth` / `ringColor` | `double` / `Color?` | `0` / tema       | Anello esterno                   |
| `badge`                   | `HUFAvatarBadge?`   | `null`           | Badge opzionale                  |
| `semanticsLabel`          | `String?`           | `null`           | Etichetta accessibilità          |


`**HUFAvatarBadge`:** costruttori `dot()`, `icon()`, `count()`, `label()`; shortcut `HUFAvatarBadge.newLabel` / `oldLabel`. Colori badge: `defaultColor` · `accent` · `success` · `warning` · `danger`. Posizioni: `topRight` · `topLeft` · `bottomRight` · `bottomLeft`.

#### HUFAvatarGroup

Gruppo di avatar sovrapposti orizzontalmente; con `max` mostra un contatore `+N` per gli elementi in eccesso.

```dart
HUFAvatarGroup(
  max: 4,
  size: HUFAvatarSize.medium,
  children: [
    HUFAvatar(initials: 'AB'),
    HUFAvatar(initials: 'CD'),
    HUFAvatar(initials: 'EF'),
    HUFAvatar(initials: 'GH'),
    HUFAvatar(initials: 'IJ'),
  ],
)
```


| Proprietà                    | Tipo              | Default          | Descrizione                         |
| ---------------------------- | ----------------- | ---------------- | ----------------------------------- |
| `children`                   | `List<HUFAvatar>` | —                | Almeno un avatar                    |
| `max`                        | `int?`            | `null`           | Limite visibili; overflow come `+N` |
| `size` / `color` / `variant` | —                 | come `HUFAvatar` | Condivisi nel gruppo                |
| `overlap`                    | `double?`         | auto             | Sovrapposizione orizzontale         |
| `ringWidth` / `ringColor`    | —                 | auto / tema      | Anello tra avatar nel gruppo        |


---

### HUFCheckbox

Checkbox con label opzionale, icone custom e glow.

**Uso singolo:**

```dart
HUFCheckbox(
  value: _checked,
  onChanged: (v) => setState(() => _checked = v),
  label: 'Accetto i termini',
  size: HUFCheckboxSize.medium,
)
```

**Uso in gruppo** (vedi sotto): passa solo `optionValue`, senza `value`/`onChanged`.


| Proprietà       | Tipo                  | Default  | Descrizione                     |
| --------------- | --------------------- | -------- | ------------------------------- |
| `value`         | `bool?`               | —        | Stato selezionato (uso singolo) |
| `onChanged`     | `ValueChanged<bool>?` | —        | Callback (uso singolo)          |
| `optionValue`   | `Object?`             | —        | ID opzione (uso in gruppo)      |
| `enabled`       | `bool`                | `true`   | Abilitato/disabilitato          |
| `size`          | `HUFCheckboxSize`     | `medium` | `small` · `medium` · `large`    |
| `glowSize`      | `HUFGlowSize?`        | tema     | Override glow                   |
| `label`         | `String?`             | `null`   | Label testuale                  |
| `checkedIcon`   | `Widget?`             | ✓        | Icona quando selezionato        |
| `uncheckedIcon` | `Widget?`             | `null`   | Icona quando non selezionato    |
| `activeColor`   | `Color?`              | tema     | Sfondo selezionato              |
| `checkColor`    | `Color?`              | tema     | Colore icona check              |
| `borderColor`   | `Color?`              | tema     | Colore bordo                    |


---

### HUFCheckboxGroup

Gruppo di checkbox con gestione selezione multipla o singola.

```dart
HUFCheckboxGroup<String>(
  multiSelect: true,
  direction: Axis.vertical,
  spacing: 12,
  initialValues: {'a'},
  onChanged: (values) => print(values),
  children: [
    HUFCheckbox(optionValue: 'a', label: 'Opzione A'),
    HUFCheckbox(optionValue: 'b', label: 'Opzione B'),
    HUFCheckbox(optionValue: 'c', label: 'Opzione C'),
  ],
)
```


| Proprietà       | Tipo                    | Default    | Descrizione                               |
| --------------- | ----------------------- | ---------- | ----------------------------------------- |
| `children`      | `List<HUFCheckbox>`     | —          | Checkbox con `optionValue`                |
| `initialValues` | `Set<T>?`               | `{}`       | Valori iniziali (non controllato)         |
| `values`        | `Set<T>?`               | —          | Valori correnti (controllato)             |
| `onChanged`     | `ValueChanged<Set<T>>?` | —          | Notifica cambiamenti                      |
| `multiSelect`   | `bool`                  | `true`     | Selezione multipla                        |
| `spacing`       | `double`                | `12`       | Spaziatura                                |
| `runSpacing`    | `double`                | `12`       | Spaziatura tra righe (Wrap)               |
| `direction`     | `Axis`                  | `vertical` | `vertical` (Column) o `horizontal` (Wrap) |


---

### HUFCheckboxCard

Card cliccabile con indicatore checkbox, titolo e sottotitolo.

```dart
HUFCheckboxCard(
  title: 'Piano Pro',
  subtitle: '€9.99/mese',
  icon: Icon(Icons.star),
  value: _selected,
  onChanged: (v) => setState(() => _selected = v),
  size: HUFCheckboxSize.medium,
)
```


| Proprietà       | Tipo                  | Default  | Descrizione                |
| --------------- | --------------------- | -------- | -------------------------- |
| `title`         | `String`              | —        | Titolo                     |
| `subtitle`      | `String?`             | `null`   | Sottotitolo                |
| `icon`          | `Widget?`             | `null`   | Icona leading              |
| `value`         | `bool?`               | —        | Stato (uso singolo)        |
| `onChanged`     | `ValueChanged<bool>?` | —        | Callback (uso singolo)     |
| `optionValue`   | `Object?`             | —        | ID opzione (uso in gruppo) |
| `enabled`       | `bool`                | `true`   | Abilitato                  |
| `size`          | `HUFCheckboxSize`     | `medium` | Dimensione                 |
| `checkedIcon`   | `Widget?`             | ✓        | Icona selezionato          |
| `uncheckedIcon` | `Widget?`             | `null`   | Icona non selezionato      |
| `activeColor`   | `Color?`              | tema     | Colore attivo              |
| `checkColor`    | `Color?`              | tema     | Colore check               |
| `borderColor`   | `Color?`              | tema     | Colore bordo               |


---

### HUFCheckboxCardGroup

Gruppo di `HUFCheckboxCard` con la stessa API di `HUFCheckboxGroup`.

```dart
HUFCheckboxCardGroup<String>(
  multiSelect: false,
  children: [
    HUFCheckboxCard(optionValue: 'basic', title: 'Basic', subtitle: 'Gratuito'),
    HUFCheckboxCard(optionValue: 'pro', title: 'Pro', subtitle: '€9.99'),
  ],
  onChanged: (values) {},
)
```

Proprietà identiche a `HUFCheckboxGroup`.

---

### HUFRadioButton

Radio button circolare con glow e label opzionale.

```dart
HUFRadioButton(
  value: _selected == 'a',
  onChanged: (_) => setState(() => _selected = 'a'),
  label: 'Opzione A',
  size: HUFRadioButtonSize.medium,
)
```


| Proprietà     | Tipo                  | Default  | Descrizione                  |
| ------------- | --------------------- | -------- | ---------------------------- |
| `value`       | `bool?`               | —        | Selezionato (uso singolo)    |
| `onChanged`   | `ValueChanged<bool>?` | —        | Callback (uso singolo)       |
| `optionValue` | `Object?`             | —        | ID opzione (uso in gruppo)   |
| `enabled`     | `bool`                | `true`   | Abilitato                    |
| `size`        | `HUFRadioButtonSize`  | `medium` | `small` · `medium` · `large` |
| `glowSize`    | `HUFGlowSize?`        | tema     | Override glow                |
| `label`       | `String?`             | `null`   | Label testuale               |
| `activeColor` | `Color?`              | tema     | Bordo/glow selezionato       |
| `dotColor`    | `Color?`              | tema     | Pallino interno              |
| `borderColor` | `Color?`              | tema     | Colore bordo                 |


---

### HUFRadioButtonGroup

Gruppo radio con selezione singola obbligatoria.

```dart
HUFRadioButtonGroup<String>(
  initialValue: 'a',
  onChanged: (value) => setState(() => _selected = value),
  children: [
    HUFRadioButton(optionValue: 'a', label: 'Opzione A'),
    HUFRadioButton(optionValue: 'b', label: 'Opzione B'),
  ],
)
```


| Proprietà      | Tipo                   | Default    | Descrizione                       |
| -------------- | ---------------------- | ---------- | --------------------------------- |
| `children`     | `List<HUFRadioButton>` | —          | Radio con `optionValue`           |
| `initialValue` | `T?`                   | —          | Valore iniziale (non controllato) |
| `value`        | `T?`                   | —          | Valore corrente (controllato)     |
| `onChanged`    | `ValueChanged<T>?`     | —          | Notifica selezione                |
| `spacing`      | `double`               | `12`       | Spaziatura                        |
| `runSpacing`   | `double`               | `12`       | Spaziatura tra righe              |
| `direction`    | `Axis`                 | `vertical` | Disposizione                      |


---

### HUFSwitch

Switch a pill con thumb animato, icona opzionale e glow.

```dart
HUFSwitch(
  value: _enabled,
  onChanged: (v) => setState(() => _enabled = v),
  label: 'Notifiche',
  icon: Icon(Icons.notifications, size: 14),
  size: HUFSwitchSize.medium,
)
```


| Proprietà            | Tipo                  | Default  | Descrizione                  |
| -------------------- | --------------------- | -------- | ---------------------------- |
| `value`              | `bool?`               | —        | Stato ON/OFF (uso singolo)   |
| `onChanged`          | `ValueChanged<bool>?` | —        | Callback (uso singolo)       |
| `optionValue`        | `Object?`             | —        | ID opzione (uso in gruppo)   |
| `enabled`            | `bool`                | `true`   | Abilitato                    |
| `size`               | `HUFSwitchSize`       | `medium` | `small` · `medium` · `large` |
| `glowSize`           | `HUFGlowSize?`        | tema     | Override glow                |
| `label`              | `String?`             | `null`   | Label testuale               |
| `icon`               | `Widget?`             | `null`   | Icona nel thumb              |
| `activeColor`        | `Color?`              | tema     | Track attivo                 |
| `thumbColor`         | `Color?`              | tema     | Colore thumb                 |
| `inactiveTrackColor` | `Color?`              | tema     | Track spento                 |
| `iconColor`          | `Color?`              | tema     | Colore icona                 |


---

### HUFSwitchGroup

Gruppo di switch indipendenti (ognuno ON/OFF).

```dart
HUFSwitchGroup<String>(
  direction: Axis.horizontal,
  children: [
    HUFSwitch(optionValue: 'email', label: 'Email'),
    HUFSwitch(optionValue: 'push', label: 'Push'),
    HUFSwitch(optionValue: 'sms', label: 'SMS'),
  ],
  onChanged: (active) {},
)
```


| Proprietà       | Tipo                    | Default      | Descrizione                   |
| --------------- | ----------------------- | ------------ | ----------------------------- |
| `children`      | `List<HUFSwitch>`       | —            | Switch con `optionValue`      |
| `initialValues` | `Set<T>?`               | `{}`         | Attivi inizialmente           |
| `values`        | `Set<T>?`               | —            | Attivi correnti (controllato) |
| `onChanged`     | `ValueChanged<Set<T>>?` | —            | Notifica cambiamenti          |
| `spacing`       | `double`                | `12`         | Spaziatura                    |
| `runSpacing`    | `double`                | `12`         | Spaziatura tra righe          |
| `direction`     | `Axis`                  | `horizontal` | Disposizione                  |


---

### HUFSlider

Slider a valore singolo con label e valore opzionale.

```dart
HUFSlider(
  label: 'Volume',
  value: _volume,
  onChanged: (v) => setState(() => _volume = v),
  min: 0,
  max: 100,
  step: 1,
  showValue: true,
  size: HUFSliderSize.medium,
)
```


| Proprietà            | Tipo                       | Default  | Descrizione                  |
| -------------------- | -------------------------- | -------- | ---------------------------- |
| `label`              | `String`                   | —        | Label obbligatoria           |
| `value`              | `double`                   | —        | Valore corrente              |
| `onChanged`          | `ValueChanged<double>?`    | —        | Callback; `null` disabilita  |
| `min`                | `double`                   | `0`      | Valore minimo                |
| `max`                | `double`                   | `100`    | Valore massimo               |
| `step`               | `double?`                  | `null`   | Incremento                   |
| `enabled`            | `bool`                     | `true`   | Abilitato                    |
| `showValue`          | `bool`                     | `false`  | Mostra valore a destra       |
| `valueFormatter`     | `String Function(double)?` | auto     | Formattazione valore         |
| `size`               | `HUFSliderSize`            | `medium` | `small` · `medium` · `large` |
| `activeColor`        | `Color?`                   | tema     | Track attivo                 |
| `inactiveTrackColor` | `Color?`                   | tema     | Track inattivo               |
| `thumbColor`         | `Color?`                   | tema     | Colore thumb                 |


---

### HUFRangeSlider

Range slider con doppio handle per selezionare un intervallo.

```dart
HUFRangeSlider(
  label: 'Prezzo',
  values: _range,
  onChanged: (v) => setState(() => _range = v),
  min: 0,
  max: 1000,
  step: 10,
  showValue: true,
  valueFormatter: (v) => '€${v.start.round()} – €${v.end.round()}',
)
```


| Proprietà            | Tipo                            | Default  | Descrizione         |
| -------------------- | ------------------------------- | -------- | ------------------- |
| `label`              | `String`                        | —        | Label obbligatoria  |
| `values`             | `RangeValues`                   | —        | Intervallo corrente |
| `onChanged`          | `ValueChanged<RangeValues>?`    | —        | Callback            |
| `min`                | `double`                        | `0`      | Minimo              |
| `max`                | `double`                        | `100`    | Massimo             |
| `step`               | `double?`                       | `null`   | Incremento          |
| `enabled`            | `bool`                          | `true`   | Abilitato           |
| `showValue`          | `bool`                          | `false`  | Mostra intervallo   |
| `valueFormatter`     | `String Function(RangeValues)?` | auto     | Formattazione       |
| `size`               | `HUFSliderSize`                 | `medium` | Dimensione          |
| `activeColor`        | `Color?`                        | tema     | Track attivo        |
| `inactiveTrackColor` | `Color?`                        | tema     | Track inattivo      |
| `thumbColor`         | `Color?`                        | tema     | Colore thumb        |


---

### HUFPopover

Pannello contestuale che si apre al tap su un [HUFButton](#hufbutton), passando `popover: HUFButtonPopover(...)`. Il popover è posizionato rispetto al pulsante (`bottom` di default) e, se non c’è spazio nel viewport, si capovolge automaticamente (es. `bottom` → `top`). All’apertura usa la stessa animazione fade/scale di [HUFSelect](#hufselect), direttamente in posizione (senza scatto dall’angolo dello schermo).

**Base** — titolo e descrizione con `HUFPopoverContent`:

```dart
HUFButton(
  label: 'Click me',
  variant: HUFButtonVariant.primary,
  popover: HUFButtonPopover(
    child: HUFPopoverContent(
      title: 'Popover Title',
      description: 'Testo secondario o istruzioni.',
    ),
  ),
)
```

**Con freccia e posizione** — `showArrow` e `placement` (`top` · `bottom` · `start` · `end`):

```dart
HUFButton(
  label: 'With Arrow',
  variant: HUFButtonVariant.outlined,
  popover: HUFButtonPopover(
    showArrow: true,
    placement: HUFPopoverPlacement.bottom,
    child: HUFPopoverContent(
      title: 'Popover with Arrow',
      description: 'La freccia indica il pulsante che ha aperto il popover.',
    ),
  ),
)
```

**Solo icona** — menu contestuale con `HUFButton.iconOnly`:

```dart
HUFButton.iconOnly(
  icon: Icon(Icons.more_horiz),
  variant: HUFButtonVariant.secondary,
  popover: HUFButtonPopover(
    showArrow: true,
    child: HUFPopoverContent(
      title: 'Azioni',
      description: 'Scegli un\'operazione.',
    ),
  ),
)
```

**Contenuto custom** — qualsiasi widget in `child` (non solo `HUFPopoverContent`):

```dart
HUFButton(
  label: 'Profilo',
  variant: HUFButtonVariant.ghost,
  icon: HUFAvatar(initials: 'SJ', size: HUFAvatarSize.small),
  popover: HUFButtonPopover(
    showArrow: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Sarah Johnson', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('@sarahj'),
        SizedBox(height: 8),
        HUFButton(label: 'Follow', size: HUFButtonSize.small, onPressed: () {}),
      ],
    ),
  ),
)
```

**Stato controllato** — `isOpen` e `onOpenChanged` (il tap sul bottone non invoca `onPressed`):

```dart
class _MenuState extends State<Menu> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return HUFButton(
      label: _open ? 'Chiudi' : 'Apri',
      popover: HUFButtonPopover(
        isOpen: _open,
        onOpenChanged: (value) => setState(() => _open = value),
        closeOnTapOutside: true,
        child: HUFPopoverContent(title: 'Menu controllato'),
      ),
    );
  }
}
```

Con `popover` impostato, il tap gestisce solo apertura/chiusura (un secondo tap sul pulsante chiude il pannello); usa `onPressed` per azioni dirette quando il popover è `null`.

| Proprietà (`HUFButtonPopover`) | Tipo                  | Default  | Descrizione                        |
| ----------------------------- | --------------------- | -------- | ---------------------------------- |
| `child`                       | `Widget`              | —        | Contenuto del popover              |
| `placement`                   | `HUFPopoverPlacement` | `bottom` | `top` · `bottom` · `start` · `end` |
| `align`                       | `HUFPopoverAlign`     | `center` | `left` · `center` · `right`        |
| `showArrow`                   | `bool`                | `false`  | Freccia verso il pulsante          |
| `offset`                      | `double?`             | auto     | Gap tra pulsante e popover         |
| `isOpen`                      | `bool?`               | —        | Stato controllato                  |
| `onOpenChanged`               | `ValueChanged<bool>?` | —        | Notifica apertura/chiusura         |
| `initialOpen`                 | `bool`                | `false`  | Stato iniziale (non controllato)   |
| `closeOnTapOutside`           | `bool`                | `true`   | Chiude al tap fuori                |

**`HUFPopoverContent`:** `title`, `description`, `child` (widget aggiuntivo sotto titolo/descrizione).

---

### HUFInput

Campo di testo con label opzionale sopra, `hintText` interno e bordo **primary** in focus (pill-shaped tramite [HUFTheme.borderRadius](#sistema-di-temi)). È la base visiva condivisa con il trigger di [HUFSelect](#hufselect).

Il parametro `type` (`HUFInputType`) definisce il comportamento (`text`, `email`, `password`, `otp`, `tel`, `number`). Tap fuori dal campo rimuove il focus.

```dart
HUFInput(
  label: 'Email',
  hintText: 'nome@esempio.it',
  controller: emailController,
  type: HUFInputType.email,
  icon: true,
  clear: true,
  isFullWidth: true,
  onChanged: (value) => debugPrint(value),
)
```

**Tipi**

| `type` | Comportamento |
| ------ | ------------- |
| `text` | Testo libero (default) |
| `email` | Solo caratteri validi per un indirizzo email |
| `password` | Testo mascherato; icona occhio a destra per mostrare/nascondere |
| `tel` | Prefisso fisso (`telPrefix`) + sole cifre nel campo |
| `otp` | Celle separate (quadrate, stessa altezza del campo); `otpLength` configurabile; focus automatico sulla cella successiva; `isFullWidth` ignorato |
| `number` | Stepper con pulsanti − / +; `numberSuffix` attaccato al valore (es. `px`); senza icona leading; `min` / `max` / `step` opzionali |

```dart
// Numero con suffisso e stepper
HUFInput(
  label: 'Width',
  controller: widthController,
  type: HUFInputType.number,
  numberSuffix: 'px',
  min: 0,
  max: 9999,
  step: 1,
  clear: true,
)

// OTP / PIN
HUFInput(
  label: 'Enter PIN',
  type: HUFInputType.otp,
  otpLength: 4,
  controller: otpController,
  icon: true,
  clear: true,
)

// Telefono con prefisso
HUFInput(
  label: 'Telefono',
  type: HUFInputType.tel,
  telPrefix: '+39',
  icon: Icons.phone_outlined,
  isFullWidth: true,
)
```

| Proprietà | Tipo | Default | Descrizione |
| --------- | ---- | ------- | ----------- |
| `label` | `String?` | — | Label sopra il campo |
| `hintText` | `String?` | — | Placeholder interno |
| `type` | `HUFInputType` | `text` | Tipo di input |
| `controller` | `TextEditingController?` | — | Testo controllato (OTP: stringa concatenata delle celle) |
| `focusNode` | `FocusNode?` | — | Focus esterno (OTP: prima cella) |
| `onChanged` | `ValueChanged<String>?` | — | Callback al cambio testo |
| `onSubmitted` | `ValueChanged<String>?` | — | Invio tastiera / OTP completo |
| `enabled` | `bool` | `true` | Abilita/disabilita |
| `readOnly` | `bool` | `false` | Solo lettura (es. trigger select) |
| `isFullWidth` | `bool` | `false` | Larghezza piena del genitore (ignorato per `otp`) |
| `icon` | `Object?` | `false` | `false`: nessuna icona; `true`: icona predefinita per il `type`; `Widget` / `IconData`: icona custom a sinistra |
| `clear` | `bool` | `false` | Icona × a destra per svuotare il valore |
| `otpLength` | `int` | `4` | Numero di celle OTP |
| `telPrefix` | `String` | `'+39'` | Prefisso mostrato per `tel` |
| `numberSuffix` | `String?` | — | Suffisso unità dopo il valore (es. `px`, `%`) per `number` |
| `min` | `int?` | — | Valore minimo per `number` |
| `max` | `int?` | — | Valore massimo per `number` |
| `step` | `int` | `1` | Incremento dei pulsanti ± per `number` |
| `obscureText` | `bool` | `false` | Testo nascosto (ignorato se `type` è `password`) |
| `autofocus` | `bool` | `false` | Focus automatico |
| `suffix` | `Widget?` | — | Widget a destra (es. freccia select) |
| `keyboardType` | `TextInputType?` | — | Override tastiera (altrimenti derivato da `type`) |
| `maxLines` | `int` | `1` | Righe del campo |

---

### HUFSelect

Select con menu a comparsa, allineato al design HeroUI. Il trigger usa [HUFInput](#hufinput) (`label`, `hintText`, `isFullWidth`, bordo in focus). Con `search: true`, all’apertura del menu il campo diventa modificabile e filtra le voci per `label` e `subtitle`. Supporta selezione singola o multipla, sezioni con intestazione e [HUFSeparator](#hufseparator), voci con `leading`/`subtitle` (es. avatar + email) e `itemBuilder` custom. Il menu si apre con animazione fade/scale nella posizione finale e, se non c’è spazio, si capovolge (`top` ↔ `bottom`). Un secondo tap sul trigger chiude il menu.

**Singola** — elenco piatto:

```dart
HUFSelect<String>(
  label: 'State',
  hintText: 'Select one',
  isFullWidth: true,
  items: const [
    HUFSelectItem(value: 'fl', label: 'Florida'),
    HUFSelectItem(value: 'ca', label: 'California'),
  ],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)
```

**Sezioni** — intestazioni e separatori tra gruppi:

```dart
HUFSelect<String>(
  label: 'Country',
  hintText: 'Select a country',
  isFullWidth: true,
  sections: [
    const HUFSelectSection(
      header: 'North America',
      items: [
        HUFSelectItem(value: 'us', label: 'United States'),
        HUFSelectItem(value: 'ca', label: 'Canada'),
      ],
    ),
    const HUFSelectSection(
      header: 'Europe',
      showSeparatorBefore: true,
      items: [
        HUFSelectItem(value: 'fr', label: 'France'),
        HUFSelectItem(value: 'de', label: 'Germany'),
      ],
    ),
  ],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)
```

**Ricerca** — filtra le opzioni mentre il menu è aperto:

```dart
HUFSelect<String>(
  label: 'State',
  hintText: 'Cerca o seleziona',
  search: true,
  isFullWidth: true,
  items: states,
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)
```

**Multipla** — checkmark sulle voci, testo nel trigger con separatori configurabili:

```dart
HUFSelect<String>(
  label: 'Countries',
  multiSelect: true,
  closeOnSelect: false,
  placement: HUFSelectPlacement.top,
  values: selected,
  onMultiChanged: (v) => setState(() => selected = v),
  items: countries,
)
```

**Voce custom** — `itemBuilder` o `leading` + `subtitle` sulle voci:

```dart
HUFSelectItem(
  value: user.id,
  label: user.name,
  subtitle: user.email,
  leading: HUFAvatar(initials: user.initials, size: HUFAvatarSize.small),
)
```

| Proprietà | Tipo | Default | Descrizione |
| --------- | ---- | ------- | ----------- |
| `label` | `String?` | — | Label sopra il trigger |
| `hintText` | `String?` | — | Placeholder interno (prioritario) |
| `placeholder` | `String` | `'Select one'` | Alias di `hintText` (retrocompatibilità) |
| `search` | `bool` | `false` | Campo di ricerca con menu aperto |
| `items` | `List<HUFSelectItem<T>>?` | — | Elenco piatto (o usa `sections`) |
| `sections` | `List<HUFSelectSection<T>>?` | — | Gruppi con header opzionale |
| `value` | `T?` | — | Valore (singola) |
| `values` | `Set<T>?` | — | Valori (multipla) |
| `onChanged` | `ValueChanged<T?>?` | — | Callback singola |
| `onMultiChanged` | `ValueChanged<Set<T>>?` | — | Callback multipla |
| `multiSelect` | `bool` | `false` | Selezione multipla |
| `isFullWidth` | `bool` | `false` | Larghezza piena del genitore |
| `placement` | `HUFSelectPlacement` | `bottom` | `top` · `bottom` (con flip automatico) |
| `closeOnSelect` | `bool` | `!multiSelect` | Chiude il menu dopo la selezione |
| `itemBuilder` | `HUFSelectItemBuilder<T>?` | — | Layout voce custom |
| `displayStringForValue` | `String Function(T)?` | — | Testo nel trigger per valore |
| `isOpen` / `onOpenChanged` | — | — | Stato aperto controllato |
| `menuOffset` | `double?` | auto | Gap tra trigger e menu |

**`HUFSelectItem`:** `value`, `label`, `subtitle`, `leading`, `enabled`. **`HUFSelectSection`:** `header`, `items`, `showSeparatorBefore`.

---

### HUFSeparator

Linea divisoria orizzontale o verticale tra blocchi di contenuto. Il colore deriva dal tema (`border`, `secondary`, `tertiary`).

**Orizzontale** — larghezza piena del genitore:

```dart
const HUFSeparator()
// oppure esplicito:
const HUFSeparator(orientation: HUFSeparatorOrientation.horizontal)
```

**Verticale** — in una `Row` con altezza definita (es. link di navigazione):

```dart
Row(
  children: [
    Text('Blog'),
    const SizedBox(width: 16),
    const HUFSeparator(orientation: HUFSeparatorOrientation.vertical),
    const SizedBox(width: 16),
    Text('Docs'),
  ],
)
```

| Proprietà | Tipo | Default | Descrizione |
| --------- | ---- | ------- | ----------- |
| `orientation` | `HUFSeparatorOrientation` | `horizontal` | `horizontal` · `vertical` |
| `variant` | `HUFSeparatorVariant` | `defaultVariant` | Intensità colore (`default` · `secondary` · `tertiary`) |

Usato anche nelle sezioni di [HUFSelect](#hufselect) (`showSeparatorBefore` su `HUFSelectSection`).

---

## Roadmap componenti

Elenco completo dei componenti HeroUI da portare su Flutter. Quelli già implementati sono spuntati.

### Implementati

- **Accordion** — `HUFAccordion`, `HUFAccordionItem`
- **Alert** — `HUFAlert`, `HUFAlertOverlay`, `hufShowAlert`
- **Alert Dialog** — `HUFAlertDialog`, `hufShowAlertDialog`
- **Toast** — `HUFToast`, `HUFToastOverlay`, `hufShowToast`
- **Drawer** — `HUFDrawer`, `HUFDrawerPanel`, `hufShowDrawer`
- **Avatar** — `HUFAvatar`, `HUFAvatarGroup`
- **Button** — `HUFButton`
- **Button Group** — `HUFButtonGroup`
- **Card** — `HUFCard`
- **Checkbox** — `HUFCheckbox`
- **Checkbox Card** — `HUFCheckboxCard`
- **Checkbox Card Group** — `HUFCheckboxCardGroup`
- **Checkbox Group** — `HUFCheckboxGroup`
- **Chip** — `HUFChip`
- **Radio Button** — `HUFRadioButton`
- **Radio Button Group** — `HUFRadioButtonGroup`
- **Slider** — `HUFSlider`
- **Range Slider** — `HUFRangeSlider`
- **Switch** — `HUFSwitch`
- **Switch Group** — `HUFSwitchGroup`
- **Popover** — `HUFButtonPopover`, `HUFPopoverContent` (via `HUFButton.popover`)
- **Input** — `HUFInput`
- **Select** — `HUFSelect`, `HUFSelectItem`, `HUFSelectSection`
- **Separator** — `HUFSeparator` (orizzontale e verticale)

### Da implementare

- **Calendar**
- **Datepicker** (single)
- **Datepicker** (range)
- **Listbox**
- **Listbox Item**
- **Meter / Progress Bar**
- **Scroll Shadow**
- **Skeleton**
- **Table**
- **Tabs**

---

## App di esempio

La cartella `example/` contiene un'app showcase interattiva con tutti i componenti implementati, switch light/dark e selettore preset tema.

```bash
cd example
flutter run
```

Pagine showcase disponibili: Accordion, Alert, Alert Dialog, Avatar, Chip, Bottoni, Button Group, Checkbox, Card, Checkbox Card, Drawer, Input, Popover, Radio Button, Select, Separator, Slider, Switch, Toast.

L’AppBar della showcase usa `HUFSelect` per il preset tema (con campione colore primary) e per il border radius globale.

---

## Licenza

MIT — vedi [LICENSE](LICENSE).

---

## Riferimenti

- [HeroUI — Sito ufficiale](https://heroui.com/)
- [HeroUI — Repository GitHub](https://github.com/heroui-inc/heroui)
- [HeroUI v3 — Documentazione](https://heroui.com/docs/react/getting-started/quick-start)
- [HeroUI — Storybook v3](https://storybook-v3.heroui.com/)

