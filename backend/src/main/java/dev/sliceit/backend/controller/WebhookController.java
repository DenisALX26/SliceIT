package dev.sliceit.backend.controller;

import com.stripe.exception.SignatureVerificationException;
import com.stripe.model.PaymentIntent;
import com.stripe.model.Event;
import com.stripe.model.EventDataObjectDeserializer;
import com.stripe.net.Webhook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/webhooks")
public class WebhookController {
    @Value("${STRIPE_WEBHOOK_SECRET}")
    private String endpointSecret;

    @PostMapping("/stripe")
public ResponseEntity<String> handleStripeWebhook(@RequestBody String payload, 
                                                  @RequestHeader("Stripe-Signature") String sigHeader) {
    Event event;

    try {
        event = Webhook.constructEvent(payload, sigHeader, endpointSecret);
        
        switch (event.getType()) {
            case "payment_intent.succeeded":
                EventDataObjectDeserializer dataObjectDeserializer = event.getDataObjectDeserializer();
                PaymentIntent intent = null;

                if (dataObjectDeserializer.getObject().isPresent()) {
                    intent = (PaymentIntent) dataObjectDeserializer.getObject().get();
                } else {
                    intent = (PaymentIntent) dataObjectDeserializer.deserializeUnsafe();
                    System.out.println("⚠️ Warning: Deserialized using unsafe method.");
                }

                if (intent != null) {
                    System.out.println("✅ PLATA REUȘITĂ! Suma: " + intent.getAmount() + " " + intent.getCurrency());
                    System.out.println("ID Tranzacție: " + intent.getId());
                }
                break;

            case "payment_intent.payment_failed":
                System.out.println("❌ Plata a eșuat!");
                break;

            default:
                System.out.println("Unhandled event type: " + event.getType());
        }

    } catch (SignatureVerificationException e) {
        System.out.println("⚠️ Eroare de semnătură: " + e.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Semnătură invalidă");
    } catch (Exception e) { 
        System.out.println("❌ Eroare la procesarea webhook-ului: " + e.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Eroare server");
    }

    return ResponseEntity.ok("Succes");
}

}
