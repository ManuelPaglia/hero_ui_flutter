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

Pannello contestuale che si apre al tap su un [HUFButton](#hufbutton), passando `popover: HUFButtonPopover(...)`. Il popover è posizionato rispetto al pulsante (`bottom` di default) e, se non c’è spazio nel viewport, si capovolge automaticamente (es. `bottom` → `top`).

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

Con `popover` impostato, il tap gestisce solo apertura/chiusura; usa `onPressed` per azioni dirette quando il popover è `null`.

| Proprietà (`HUFButtonPopover`) | Tipo                  | Default  | Descrizione                        |
| ----------------------------- | --------------------- | -------- | ---------------------------------- |
| `child`                       | `Widget`              | —        | Contenuto del popover              |
| `placement`                   | `HUFPopoverPlacement` | `bottom` | `top` · `bottom` · `start` · `end` |
| `showArrow`                   | `bool`                | `false`  | Freccia verso il pulsante          |
| `offset`                      | `double?`             | auto     | Gap tra pulsante e popover         |
| `isOpen`                      | `bool?`               | —        | Stato controllato                  |
| `onOpenChanged`               | `ValueChanged<bool>?` | —        | Notifica apertura/chiusura         |
| `initialOpen`                 | `bool`                | `false`  | Stato iniziale (non controllato)   |
| `closeOnTapOutside`           | `bool`                | `true`   | Chiude al tap fuori                |

**`HUFPopoverContent`:** `title`, `description`, `child` (widget aggiuntivo sotto titolo/descrizione).

---

## Roadmap componenti

Elenco completo dei componenti HeroUI da portare su Flutter. Quelli già implementati sono spuntati.

### Implementati

- **Accordion** — `HUFAccordion`, `HUFAccordionItem`
- **Alert** — `HUFAlert`, `HUFAlertOverlay`, `hufShowAlert`
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

### Da implementare

- **Alert Dialog**
- **Calendar**
- **Combobox** (single select)
- **Combobox** (multiple select)
- **Datepicker** (single)
- **Datepicker** (range)
- **Drawer**
- **Dropdown**
- **Input — text**
- **Input — number**
- **Input — email**
- **Input — password**
- **Input — search**
- **Input — tel**
- **Input — OTP**
- **Listbox**
- **Listbox Item**
- **Meter / Progress Bar**
- **Scroll Shadow**
- **Select**
- **Separator** (horizontal)
- **Separator** (vertical)
- **Skeleton**
- **Table**
- **Tabs**
- **Toast**

---

## App di esempio

La cartella `example/` contiene un'app showcase interattiva con tutti i componenti implementati, switch light/dark e selettore preset tema.

```bash
cd example
flutter run
```

Pagine showcase disponibili: Accordion, Alert, Avatar, Chip, Bottoni, Button Group, Checkbox, Card, Checkbox Card, Popover, Radio Button, Slider, Switch.

---

## Licenza

MIT — vedi [LICENSE](LICENSE).

---

## Riferimenti

- [HeroUI — Sito ufficiale](https://heroui.com/)
- [HeroUI — Repository GitHub](https://github.com/heroui-inc/heroui)
- [HeroUI v3 — Documentazione](https://heroui.com/docs/react/getting-started/quick-start)
- [HeroUI — Storybook v3](https://storybook-v3.heroui.com/)

