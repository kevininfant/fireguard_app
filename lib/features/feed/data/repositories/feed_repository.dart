import 'package:fireguard_app/features/feed/data/models/featured_story_model.dart';
import 'package:fireguard_app/features/feed/data/models/feed_article_model.dart';

class FeedRepository {
  final List<FeaturedStoryModel> _defaultStories = const [
    FeaturedStoryModel(
      id: 'fs_1',
      tag: 'SPOTLIGHT',
      title: 'Fire Marshall Spotlight: Chief Rodriguez',
      subtitle: 'Leading the charge in urban chemical safety protocols.',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600',
      fullContent:
          'Chief Rodriguez brings 22 years of emergency management experience to urban chemical containment. In this exclusive interview, he highlights the implementation of automated suppression valves, real-time gas monitoring, and mandatory cross-agency chemical spill response drills across industrial corridors.',
    ),
    FeaturedStoryModel(
      id: 'fs_2',
      tag: 'INNOVATION',
      title: 'Safety Innovation 2024',
      subtitle: 'Next-gen respirators and heat-shielding tech.',
      imageUrl:
          'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600',
      fullContent:
          'Discover the newest line of smart respirators equipped with Bluetooth telemetry, active carbon filtration indicators, and thermal HUD visors that display ambient temperature map overlays directly to emergency responders on site.',
    ),
    FeaturedStoryModel(
      id: 'fs_3',
      tag: 'COMPLIANCE',
      title: '2024 OSHA Standards Guide',
      subtitle: 'Key compliance updates for hazardous facility management.',
      imageUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=600',
      fullContent:
          'OSHA has issued updated compliance frameworks regarding high-density warehousing and chemical storage facilities. Key mandates include upgraded sprinkler discharge rates, mandatory dual-action alarm switches, and bi-annual safety audits.',
    ),
  ];

  final List<FeedArticleModel> _defaultArticles = const [
    FeedArticleModel(
      id: 'art_1',
      category: 'Code Update',
      readTime: '3h ago',
      title: 'NFPA 20: Standard for Centrifugal Fire Pumps',
      description:
          'Summary of the 2024 revisions affecting high-rise industrial installations and automatic transfer switch ratings.',
      authorName: 'Archie Miller',
      authorRole: 'EHS Code Specialist',
      authorInitials: 'AM',
      actionText: 'READ MORE',
      imageUrl:
          'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=600',
      fullContent:
          'The 2024 edition of NFPA 20 focuses on electric motor-driven fire pumps in high-rise structures. Key additions mandate dual electric utility services or secondary diesel generator backups for pumps serving facilities over 75 feet in height. Furthermore, annual hydrostatic testing protocols have been updated to ensure zero pressure degradation across 30-minute test windows.',
    ),
    FeedArticleModel(
      id: 'art_2',
      category: 'Training',
      readTime: '6 min read',
      title: 'Building a Culture of Industrial Vigilance',
      description:
          'Tactical drills and cross-department protocols that reduce workplace hazardous spill response time by 40%.',
      quote:
          '"Safety is not merely compliance; it is an active mindset that prevents disasters before they ignite."',
      authorName: 'Elena Rostova',
      authorRole: 'Safety Director',
      authorInitials: 'ER',
      actionText: 'EXPLORE GUIDE',
      imageUrl:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600',
      fullContent:
          'Workplace drills must evolve beyond simple fire alarm evacuations. By establishing real-time hazard identification boards, rotating safety wardens, and running simulated chemical release scenarios every quarter, facilities experience a significant reduction in near-miss incidents.',
    ),
    FeedArticleModel(
      id: 'art_3',
      category: 'Drill Insight',
      readTime: '4 min watch',
      title: 'NFPA 70E: Electrical Safety in the Workplace',
      description:
          'Arc flash boundary calculations and personal protective equipment categories explained with real plant footage.',
      authorName: 'Marcus Thorne',
      authorRole: 'Lead Electrical Inspector',
      authorInitials: 'MT',
      actionText: 'WATCH DRILL',
      imageUrl:
          'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?w=600',
      isVideo: true,
      fullContent:
          'Understanding Arc Flash boundaries is critical for maintenance personnel. This operational walkthrough details NFPA 70E PPE Category 4 requirements, including 40 cal/cm² arc flash suits, voltage-rated insulated tools, and zero-energy verification procedures.',
    ),
  ];

  Future<List<FeaturedStoryModel>> getFeaturedStories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _defaultStories;
  }

  Future<List<FeedArticleModel>> getArticles({String category = 'All', String searchQuery = ''}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var results = _defaultArticles;
    if (category != 'All') {
      results = results.where((a) => a.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      results = results
          .where((a) =>
              a.title.toLowerCase().contains(q) ||
              a.description.toLowerCase().contains(q) ||
              a.authorName.toLowerCase().contains(q))
          .toList();
    }
    return results;
  }
}
