const String defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.sams.fish",
    "displayName": "Sam's Fish",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": [],
    "shippingMethods": [
      {
        "amount": "0.00",
        "detail": "Available within an hour",
        "identifier": "in_store_pickup",
        "label": "In-Store Pickup"
      },
      {
        "amount": "4.99",
        "detail": "5-8 Business Days",
        "identifier": "flat_rate_shipping_id_2",
        "label": "UPS Ground"
      },
      {
        "amount": "29.99",
        "detail": "1-3 Business Days",
        "identifier": "flat_rate_shipping_id_1",
        "label": "FedEx Priority Mail"
      }
    ]
  }
}''';

/// Sample configuration for Google Pay. Contains the same content as the file
/// under `assets/default_payment_profile_google_pay.json`.
// "environment": "PRODUCTION",
const String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "PRODUCTION",
  
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "Gateway",
            "gatewayMerchantId": "BCR2DN4TZ2J63RB6"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "BCR2DN4TZ2J63RB6",
      "merchantName": "online books app"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';

const String basicGooglePayIsReadyToPay = '''{
  "apiVersion": 2,
  "apiVersionMinor": 0,
  "allowedPaymentMethods": [
    {
      "type": "CARD",
      "parameters": {
        "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
        "allowedCardNetworks": ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"]
      }
    }
  ]
}''';

const String basicGooglePayLoadPaymentData = '''{
  "apiVersion": 2,
  "apiVersionMinor": 0,
  "merchantInfo": {
    "merchantName": "online books app"
  },
  "allowedPaymentMethods": [
    {
      "type": "CARD",
      "parameters": {
        "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
        "allowedCardNetworks": ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"]
      },
      "tokenizationSpecification": {
        "type": "PAYMENT_GATEWAY",
        "parameters": {
          "gateway": "Gateway",
          "gatewayMerchantId": "BCR2DN4TZ2J63RB6"
        }
      }
    }
  ],
  "transactionInfo": {
    "totalPriceStatus": "FINAL",
    "totalPrice": "12.34",
    "currencyCode": "USD"
  }
}''';

const String invalidGooglePayIsReadyToPay = '''{
  "apiVersion": 2,
  "apiVersionMinor": 0,
  "allowedPaymentMethods": [
    {
      "type": "CARD",
      "parameters": {}
    }
  ]
}''';

const String invalidGooglePayLoadPaymentData = '''{
  "apiVersion": 2,
  "apiVersionMinor": 0,
  "merchantInfo": {
    "merchantName": "online shop"
  },
  "allowedPaymentMethods": [
    {
      "type": "CARD",
      "parameters": {
        "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
        "allowedCardNetworks": ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"]
      },
      "tokenizationSpecification": {
        "type": "PAYMENT_GATEWAY",
        "parameters": {
          "gateway": "example",
          "gatewayMerchantId": "BCR2DN4TZ2J63RB6"
        }
      }
    }
  ],
  "transactionInfo": {
    "totalPriceStatus": "FINAL",
    "totalPrice": "12.34",
    "currencyCode": "USD"
  }
}''';
