# Talyra - Instructions projet

## Langue et communication

- Répondre en français, de façon directe et concise.
- Ne pas introduire de complexité, dépendance, service externe ou fonctionnalité sans nécessité explicite.
- Expliquer l’impact métier et technique avant tout changement structurel : schéma, authentification, sécurité, paiement ou déploiement.
- Ne jamais modifier des fichiers hors périmètre d’une tâche.

## Contexte produit

Talyra est le back-office commercial français des professionnels du mariage : décoratrices, negafas, wedding planners et secondairement photo/vidéo.

Le parcours MVP à préserver est :

prospect -> devis envoyé -> devis signé -> acompte suivi

Le portail couple est mobile-first, accessible sans compte par lien sécurisé, et doit toujours mettre en avant une seule action suivante : signer, demander une modification ou payer.

Ne pas ajouter au MVP :

- Marketplace, vente de leads ou commission sur les mariages.
- Gestion des invités, RSVP, plan de table, budget global du couple ou fournisseurs.
- Gestion de stocks, tenues, galerie photo/vidéo ou livraison média.
- Multi-activité ou multi-identité dans un tenant.
- Chat complet, API WhatsApp/Meta, SMS, Stripe Connect ou paiements par carte.
- Fonctionnalités prévues après le MVP sans validation explicite : automatisations, questionnaires, prise de rendez-vous, import CSV/iCal, centre de notifications, multi-utilisateur et Stripe Billing.

## Stack actuelle

- Backend : NestJS 11, TypeScript, Prisma 7, PostgreSQL, Better Auth.
- Frontend : TanStack Start, React 19, TypeScript, Vite, TanStack Router et Query.
- Interface : Tailwind CSS 4, shadcn, Base UI, Lucide.
- Observabilité déjà présente côté frontend : Sentry et PostHog.
- Cible d’architecture du cahier des charges : monolithe modulaire NestJS, PostgreSQL, Redis/BullMQ et déploiement Dokploy/Hetzner.

Ne pas considérer Redis, BullMQ, Dokploy ou Stripe comme déjà intégrés sans vérifier le dépôt.

## Frontend et backend

- Le frontend TanStack ne contient aucune règle métier critique, aucun calcul financier de référence et aucune décision d’autorisation.
- Le backend NestJS reste la source de vérité pour les règles métier, permissions, calculs, signatures, échéances et transitions de statut.
- Valider à nouveau côté serveur toute donnée venant du frontend ou du portail couple.
- Concevoir les écrans pour mobile, avec états chargement, erreur et vide.
- Ne pas créer de route, composant ou endpoint avant d’avoir identifié son cas d’usage MVP et son module propriétaire.

## Multi-tenant et sécurité

Ces invariants sont non négociables :

- Chaque donnée métier appartient à un tenant et porte `tenant_id`.
- Les accès aux données sont isolés par tenant ; aucun tenant ne peut lire, modifier ou deviner une ressource d’un autre tenant.
- Toute nouvelle table métier doit prévoir son isolation tenant, sa politique RLS et ses tests d’isolation.
- Le rôle applicatif ne doit pas disposer de `BYPASSRLS`.
- Le contexte tenant est défini dans une transaction, jamais via une valeur globale réutilisable.
- Les liens de portail sont opaques, hashés, limités à un dossier, expirables et révocables.
- Ne jamais exposer de secret, jeton, donnée personnelle ou preuve de signature dans les logs, erreurs ou réponses API.
- Toute route publique doit être protégée contre l’énumération, le rejeu et l’abus.

## Règles métier critiques

- Les créneaux utilisent le fuseau Europe/Paris et sont stockés correctement en UTC.
- Les options expirent de manière idempotente.
- Un même tenant ne peut pas confirmer deux fois une même ressource sur un créneau qui se chevauche.
- Les totaux monétaires sont calculés uniquement côté serveur, en unités monétaires sûres, avec arrondis explicites.
- Un devis envoyé est versionné ; toute modification crée une nouvelle version ou un avenant.
- Un devis signé, un contrat, une facture et leur preuve ne sont jamais modifiés ni supprimés.
- La signature est atomique : documents figés, créneaux confirmés, facture d’acompte, échéancier et événements associés.
- Les paiements MVP sont hors ligne : virement, espèces ou chèque. Ils ne sont jamais considérés reçus automatiquement.
- Chaque opération sensible crée une trace immuable dans `ActivityLog`.
- Les notifications et jobs externes doivent être idempotents et traçables.

## Qualité et tests

- Ajouter ou adapter les tests à chaque changement de règle métier, de sécurité ou de persistance.
- Les flux critiques exigent des tests d’intégration ou E2E : isolation tenant, anti-double-booking, signature, versionnement de devis, échéancier et portail couple.
- Avant une migration, vérifier son impact sur les données existantes, RLS, contraintes et rollback.
- Ne pas utiliser `db:reset`, migration destructive ou suppression de données sans accord explicite.
- Lancer les vérifications pertinentes depuis le bon sous-projet : `backend/` ou `front-end/`.
- Vérifier le gestionnaire de paquets et les scripts avant de les exécuter ; le script frontend actuel dépend d’un shell Unix et peut échouer sous PowerShell Windows.

## Git et périmètre des changements

- Garder les changements petits, cohérents et limités à la demande.
- Ne pas modifier ni annuler des changements utilisateur existants.
- Ne jamais committer de secrets, fichiers `.env`, sorties de build, fichiers générés ou données locales.
- Ne pas appliquer de refactor global pendant l’implémentation d’une fonctionnalité MVP.
- Signaler toute contradiction entre une demande et ce document avant d’implémenter.
