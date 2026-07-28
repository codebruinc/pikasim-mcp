# Product lines — what to buy for which intent

Always pull live prices/coverage from the API or MCP tools at decision time;
nothing here is a price list.

## 1. Data eSIMs (most purchases)

Anonymous data-only plans, 190+ countries, from $0.75. Country, regional
(e.g. Europe), and global plans; fixed-data and daily-reset ("unlimited")
variants; most are top-uppable later (`get_topup_options` / `topup_esim`).

**Use when:** travel data, backup connectivity, a device that just needs
internet, privacy-conscious browsing.
**Not for:** making calls, sending/receiving SMS — data-only is data-only.
The buyer's device must be eSIM-capable and carrier-unlocked.

Delivery: an install/invoice URL with QR code + manual codes + setup
instructions. Hand over that URL. The wallet dashboard and `list_esims` /
`get_esim_status` track usage afterward.

## 2. Phone-number eSIMs (voice + SMS + data)

REAL carrier numbers, not VoIP:

- **US plans** — a +1 number on AT&T or T-Mobile.
- **Local country plans** — e.g. Europe-wide with a French +33 number,
  Australia, Vietnam, Mongolia, Maldives.
- **Global plans** — one number, coverage across 157 countries.

**Use when:** the user (or agent) needs to make/receive calls, receive SMS on
a persistent number, or have a working phone number while traveling.

Gotchas worth knowing before recommending:
- The number is carrier-assigned at ACTIVATION and appears in the device's
  settings — it is not known at purchase time.
- Roaming voice registration is sensitive to 5G: if calls/SMS misbehave,
  forcing the device to 4G/LTE fixes most cases.
- Toll-free/premium and some non-US prefixes are blocked by the operator on US
  plans (fraud prevention) — that's policy, not a defect.

## 3. SMS verification numbers (no eSIM involved)

Receive-only numbers for getting codes; nothing to install.

- **Quick verification** — one-time code on a temporary number:
  `search_sms_services` → `get_sms_service_countries` →
  `order_sms_verification` → poll `check_sms_verification`.
  **Auto-refunds to the wallet if no code arrives in 20 minutes.**
- **Rentals** — keep a number days-to-months, receive unlimited codes:
  `list_sms_rentals` (live stock) → `rent_sms_number` →
  `get_sms_rental_messages`, extend with `extend_sms_rental`.

**Use when:** signing up for a service that demands a phone number, testing
SMS flows, one-off OTP needs.

Hard expectation to set: **no provider can guarantee that one specific service
delivers a code to virtual numbers** — some services blocklist ranges. If a
quick verification gets nothing, the auto-refund is the remedy; try a
different country or a rental instead of retrying the same combination. For
persistent, real-carrier SMS the phone-number eSIMs (line 2) are the stronger
option.

## Choosing quickly

| Intent | Buy |
|---|---|
| "data in Japan next week" | data eSIM (country plan) |
| "multi-country Europe trip" | data eSIM (regional plan) |
| "I need a US number for calls/texts" | US phone plan |
| "receive one WhatsApp/Telegram code" | quick SMS verification |
| "a number I can keep for a month" | SMS rental (receive-only) or phone plan (full service) |
| "agent needs internet for a task" | smallest data eSIM that covers the location |
