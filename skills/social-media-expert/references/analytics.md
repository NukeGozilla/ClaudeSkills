# Analytics & Optimization Playbook

Read this when the user asks about performance: "why isn't my account growing?", "analyze my engagement," "what should I test?", "is this post/strategy working?", or any flavor of diagnosis question.

## Table of contents

1. Pick the right metrics for the user's goal
2. Platform-specific metrics that matter (and the ones that don't)
3. The diagnostic framework — why did this post flop?
4. Account-level diagnosis — why has growth plateaued?
5. A/B testing on social (done right)
6. Attribution basics — what can and can't be measured
7. Building a simple monthly review

---

## 1. Pick the right metrics for the user's goal

The most common mistake: optimizing for the wrong metric. A creator optimizing follower count will produce different content than one optimizing for engaged comments or for leads. Pin the goal first.

### Goal → primary metric mapping

| User's goal | Primary metric(s) | Secondary |
|---|---|---|
| Awareness / reach | Impressions, reach, views | New follower rate |
| Engagement / community | Comments/post, conversation depth, DM replies | Engagement rate |
| Leads / sales | Link clicks, website visits from social, attributed signups | Save rate, DM rate |
| Authority / positioning | Saves, shares, "thought leader" tagged comments, inbound opportunities | Follower quality (who, not how many) |
| Community / depth | DMs, replies, Stories interactions, reply rates | Engagement rate among existing followers |

If the user is trying to "grow on social" without a clearer goal underneath, push them to pick one. "Grow" without a direction leads to random optimization.

## 2. Platform-specific metrics that matter (and the ones that don't)

Each platform's native analytics throw a lot at you. These are the ones worth paying attention to.

### LinkedIn

**Matters:**
- **Impressions** (how many saw it)
- **Dwell time / read time** (LinkedIn doesn't expose this directly, but longer posts with lots of "expands" are a proxy)
- **Reactions, comments, reposts** (separately, not combined — comments weigh more in the algorithm)
- **New connections and follows per post**
- **Profile views** (lagging indicator that posts are working)

**Ignore:**
- **Likes alone** — too easy, too noisy
- **Reach on posts with links** — artificially suppressed, not useful for comparison

### X

**Matters:**
- **Impressions**
- **Engagements** (mostly replies > retweets > likes > bookmarks in terms of what the algo rewards)
- **Profile visits from posts**
- **Follows from specific posts**
- **Bookmark rate** (often correlates with genuinely useful content)

**Ignore:**
- **Like count in isolation** — too easy to get, doesn't predict much.
- **Gross "engagements" number** — splitting by type is more useful.

### Instagram

**Matters (for Reels):**
- **Reach** (especially "non-followers reached" — the growth signal)
- **Average watch time + completion rate** (the retention signal that drives distribution)
- **Saves and shares** (the two strongest engagement signals for distribution)
- **Follows from this post**

**Matters (for carousels):**
- **Save rate**
- **Swipe-through rate** (rough proxy: if comments mention specific later slides, people are swiping)

**Matters (for Stories):**
- **Replies and DMs**
- **Sticker interactions** (polls, Qs)
- **Exit rate** (when people leave — helps you see which stories kill a sequence)

**Ignore:**
- **Likes in isolation** — IG has been de-emphasizing likes for years.

### TikTok

**Matters:**
- **Average watch time + completion rate** (the primary ranking signal)
- **Rewatch rate** — if people loop, the algo pushes hard
- **Shares** (the strongest distribution signal)
- **Follows from this post**
- **For You Page impressions** (vs. impressions from followers — the discovery signal)

**Ignore:**
- **Likes alone**
- **Comments without context** (TikTok comments skew random)

### YouTube

**Matters (for long-form):**
- **Click-through rate (CTR)** on thumbnail/title (industry average ~4-5%; 8%+ is strong)
- **Average view duration + retention curve** (where do people drop off?)
- **Watch time** (total minutes; YouTube's #1 ranking factor)
- **Subscribers gained per video**

**Matters (for Shorts):**
- **Swipe-away rate** (similar to TikTok retention)
- **Rewatch rate**

**Ignore:**
- **Views alone** without duration context — 10k views at 20% retention is worse than 3k views at 80% retention.

## 3. The diagnostic framework — why did this post flop?

When a user asks "why did this post flop?" or "why did this one work and the other didn't?", work through this checklist. Don't guess; walk through systematically.

### Step 1: Did it get distribution, or did the algorithm kill it?

- Check impressions vs. the user's typical range for that platform and format.
- Low impressions → distribution problem (algorithmic suppression or weak hook causing early drop-off).
- Normal/high impressions but low engagement → content/message problem.

### Step 2: If low distribution — what's the likely cause?

- **Hook weakness:** First line/frame didn't earn dwell time. Compare the opening to a recent hit.
- **External link in post:** Both LinkedIn and Facebook suppress these. Check.
- **Format mismatch:** Text-only post when video was what the user normally performs on? Format matters.
- **Timing:** Posted at a bad time for the user's audience (rare culprit, but possible if significantly off-schedule).
- **Topic saturation:** Everyone was posting about the same news; the post got buried.

### Step 3: If distribution was fine but engagement tanked — what's the likely cause?

- **Content didn't deliver on the hook.** Hook promised something the body didn't cash.
- **No clear takeaway.** Reader reached the end and thought "so what?"
- **Too long/short for the platform.** 3-paragraph LinkedIn posts sometimes underperform 10-paragraph ones and vice versa; look at what's working for the user recently.
- **Wrong audience.** Good content, but not for the people who saw it (often a sign of algorithm targeting drift).

### Step 4: Was it actually a flop?

- Check save rate — sometimes a "low engagement" post had high saves, which is often more valuable.
- Check follower quality gained — 5 high-intent followers is worth more than 200 random likes.
- Check DMs — the post that triggers a DM is often the real win.

## 4. Account-level diagnosis — why has growth plateaued?

"I'm posting consistently and not growing" is one of the most common questions. Here's the structured diagnosis.

### Look at four things, in order:

**1. Positioning — is it clear?**
- If you dropped someone into the user's last 5 posts cold, could they articulate what the user is about?
- If not: positioning is the problem; fix this before anything else.

**2. Hook quality — is it competitive?**
- Compare the user's recent hooks to the top posts in their niche.
- Are they sharper, more specific, or weaker?
- If weaker: invest in hook-writing; most other changes won't matter until the hook is working.

**3. Cadence and consistency — is it genuinely regular?**
- Posts per week for the last 12 weeks. Volatility is a growth-killer.
- If cadence is erratic: fix this before tweaking content strategy.

**4. Audience alignment — are the right people following?**
- Look at follower demographics (native analytics).
- Do they match the user's ICP? Or is there drift (e.g., wanted founders, got marketers)?
- If misaligned: content may be drifting off-topic, or a single viral post pulled in a mismatched audience. Correct by doubling down on the pillar that attracts the right people.

### Ceilings that are real

Some growth "plateaus" aren't plateaus; they're natural ceilings:
- The user's niche has a natural audience size. A B2B niche on LinkedIn maxes out at 50k-200k for most operators; a consumer lifestyle account can reach millions. Know the realistic ceiling before assuming the user is failing.
- 6 months of consistent quality posting at a fixed cadence will usually double a small account; less consistent cadence won't.

## 5. A/B testing on social (done right)

Social platforms don't give you true A/B test infrastructure for organic content, but you can still run structured experiments. Rules:

- **Test one variable at a time.** If you change the hook AND the image AND the time of day, you learn nothing.
- **Test with enough volume.** One post is an anecdote. 5-10 posts per variant is meaningful.
- **Control for topic.** If you test "long vs. short captions" across a product post and a personal post, you're testing two things. Keep topic constant.
- **Define success upfront.** Impressions? Saves? Follows? Pick before running the test.

### Common tests that produce useful learnings

- **Hook style A vs. B** (e.g., "specific number" vs. "dialogue opener") across 10 posts each
- **Carousel vs. single post** on the same topic
- **Caption length** (short/medium/long) for IG Reels
- **Thumbnail style** on YouTube
- **Posting time** (but only if the swing is significant; minor time differences rarely matter)

### Tests that usually don't produce useful learnings

- **Hashtag sets** on IG (too many variables; platform-level changes muddy results)
- **Emoji vs. no emoji** (marginal)
- **Single-word CTA tweaks**
- **Anything tested over <5 posts per variant**

## 6. Attribution basics — what can and can't be measured

Users often want to know "how many sales came from social?" Some honest ground truth:

**Trackable:**
- Link clicks from a post to your site (UTM parameters)
- Signups with UTM tracking
- DMs that lead to sales (track manually)
- Direct-to-checkout via shoppable posts

**Partially trackable:**
- Branded search lift (check Google Search Console for branded queries over time — a strong social presence raises these)
- Self-reported "how did you hear about us?" at signup or checkout
- Followers → email subscribers → customers (pipeline-style)

**Hard to track but real:**
- Brand familiarity at first purchase ("I'd seen their posts for months")
- Inbound partnerships, press, speaking gigs triggered by a post
- Trust compounding over time

Don't oversell attribution certainty. A lot of social ROI shows up indirectly and on a lag.

## 7. Building a simple monthly review

A 30-minute monthly review is enough. Template:

**What happened?**
- Top 3 posts by reach
- Top 3 posts by engagement
- Top 3 posts by saves/shares
- Total reach, follower change, engagement rate

**What worked?**
- Common patterns across the top performers (hook type, topic, format)
- One sentence on why

**What didn't?**
- Bottom 3 posts and a plausible reason each

**What will I test next month?**
- One specific change to try (hook pattern, format, cadence, topic shift)
- How you'll know if it worked

Run this every month, keep them in a single doc, and you'll have a real body of learning by month 6. Most people don't do this. The ones who do compound.
